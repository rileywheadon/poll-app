from flask import Blueprint, render_template, redirect, url_for
from flask import request, session, make_response
from datetime import datetime, timedelta
import requests

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import on_cooldown, get_days_behind, query_poll_details

admin = Blueprint('admin', __name__, template_folder='templates/admin')


@admin.route("/admin/users")
@requires_admin
def users():

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the headers from the HTTP request, if they exist
    column = request.args.get("column") or "username"
    search = request.args.get("search") or ""

    # Include similar values in the query, unless we are searching by ID
    value = "%{}%".format(search) if column != "id" else search

    # Check that the search column is valid to prevent SQL injection
    if column not in ["username", "email", "id"]:
        return ""

    # Query the database for all users matching the search
    query = f"""
    SELECT *
    FROM user
    WHERE {column}
    LIKE ?
    """
    res = cur.execute(query, (value,))
    users = [dict(row) for row in res.fetchall()]

    # Update the cooldown state for each user
    for user in users:
        user["on_cooldown"] = on_cooldown(user)

    # If the request is internal, only re-render the user list
    target = request.headers.get("HX-Target")
    if target and target == "users-list":
        return render_template("users-list.html", users=users)

    # Render the page with all searched users
    session["admin"] = True
    session["tab"] = "users"
    form = {"column": column, "search": search}
    return render_template("users.html", session=session, users=users, form=form)


@admin.route("/admin/users/resetcooldown")
@requires_admin
def resetcooldown():

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the user ID from the HTTP request
    user_id = request.args.get("user_id")

    # Update the user's next_poll_allowed value
    query = """
    UPDATE user 
    SET next_poll_allowed = ?
    WHERE id = ?
    """
    now = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    res = cur.execute(query, (now, user_id))
    db.commit()

    # UI Changes are handled in Javascript
    return ""


@admin.route("/admin/polls")
@requires_admin
def polls():

    # Get a db connection
    db = get_db()
    cur = db.cursor()

    # Get the request data or a default value if not provided
    column = request.args.get("column") or "creator"
    search = request.args.get("search") or ""
    sort = request.args.get("sort") or "date_created"
    direction = request.args.get("sort_direction") or "DESC"

    # Check column, sort, direction are valid to avoid SQL injection
    column_valid = column in ["creator", "question", "poll.id"]
    sort_valid = sort in ["date_created"]
    direction_valid = direction in ["DESC", "ASC"]
    if not (column_valid and sort_valid and direction_valid):
        return ""

    # Include similar values in the query, unless we are searching by ID
    value = "%{}%".format(search) if column != "poll.id" else search

    # Construct a query for selecting the poll types
    types = request.args.getlist("search_type") or []
    type_query = " OR ".join([f"poll.poll_type='{t}'" for t in types])
    if type_query == "":
        type_query = "True"

    # Construct a query for selecting the poll boards
    boards = request.args.getlist("board") or []
    board_query = " OR ".join([f"board_id={b}" for b in boards])
    if board_query == "":
        board_query = "True"

    # Create the query and build the values tuple
    poll_query = f"""
    SELECT
        poll.*, 
        user.username AS creator,
        user.email AS creator_email
    FROM poll
        INNER JOIN user ON user.id = poll.creator_id
    WHERE ({column} LIKE ?) AND ({type_query}) AND poll.id IN (
        SELECT DISTINCT poll_id
        FROM poll_board
        WHERE ({board_query})
    )
    ORDER BY {sort} {direction}
    """
    res = cur.execute(poll_query, (value,))
    ids = [poll["id"] for poll in res.fetchall()]
    polls = [query_poll_details(id) for id in ids]

    # Get the list of poll boards
    query = "SELECT * FROM board"
    boards = [dict(b) for b in cur.execute(query).fetchall()]

    # If the request is internal, only re-render the user list
    target = request.headers.get("HX-Target")
    if target and target == "polls-list":
        return render_template("polls-list.html", polls=polls)

    # Otherwise, render the entire users page
    session["admin"] = True
    session["tab"] = "polls"
    form = {"column": column, "search": search}
    return render_template(
        "polls.html",
        session=session,
        polls=polls,
        boards=boards,
        form=form
    )


@admin.route("/admin/reports")
@requires_admin
def reports():

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the reports, from newest to oldest
    query = """
    SELECT *
    FROM report
    ORDER BY timestamp DESC
    """
    res = cur.execute(query).fetchall()
    reports = [dict(report) for report in res]

    # If there are no reports, return nothing
    session["admin"] = True
    session["tab"] = "reports"
    return render_template("reports.html", session=session, reports=reports)


@admin.route("/admin/stats")
@requires_admin
def stats():

    # Get a database connection
    db = get_db()
    cur = db.cursor()
    stats = {"responses": [], "polls": []}

    # Get the datetimes 1 day, 7 days, and 30 days in the past
    days = [get_days_behind(x) for x in (1, 7, 30)]

    # Get the number of responses in the last 1 day, 7 days, 30 days
    response_query = """
    SELECT COUNT(*) AS count
    FROM response
    WHERE timestamp > ?
    """

    # Get the number of new polls in the last 1 day, 7 days, 30 days
    poll_query = """
    SELECT COUNT(*) AS count
    FROM poll
    WHERE date_created > ?
    """

    # Execute the queries on each date
    def count(q, d): return dict(cur.execute(q, (d,)).fetchone())["count"]
    for day in days:
        stats["responses"].append(count(response_query, day))
        stats["polls"].append(count(poll_query, day))

    session["admin"] = True
    session["tab"] = "stats"
    return render_template("stats.html", session=session, stats=stats)


@admin.route("/admin/boards")
@requires_admin
def boards():

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the list of boards
    query = "SELECT * FROM board"
    boards = [dict(b) for b in cur.execute(query).fetchall()]

    # Render the template
    session["admin"] = True
    session["tab"] = "boards"
    return render_template("boards.html", session=session, boards=boards)


@admin.route("/admin/boards/create")
@requires_admin
def create_board():

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Check that the board name is unique
    name = request.args.get("name")
    query = "SELECT * FROM board WHERE name=?"

    # If the name is not unique, do nothing and notify the user
    if cur.execute(query, (name,)).fetchone() is not None:
        r = make_response("")
        notification = '{"notification": "Board already exists!"}'
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", "none")
        return r

    # Add the board to the database
    query = "INSERT INTO board (name) VALUES (?)"
    cur.execute(query, (name,))
    db.commit()

    # Get the list of boards
    query = "SELECT * FROM board"
    boards = [dict(b) for b in cur.execute(query).fetchall()]

    # Render the boards list again
    r = make_response(render_template("boards-list.html", boards=boards))
    notification = '{"notification": "Board created!"}'
    r.headers.set("HX-Trigger", notification)
    return r


@admin.route("/admin/boards/delete/<board_id>")
@requires_admin
def delete_board(board_id):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Remove the board and all connected polls from the database
    board_query = "DELETE FROM board WHERE id=?"
    poll_board_query = "DELETE FROM poll_board WHERE board_id=?"
    poll_query = """
    DELETE FROM poll 
    WHERE id IN (
        SELECT poll_id 
        FROM poll_board 
        WHERE board_id=?
    )
    """

    # Execute the queries, starting with poll_query
    cur.execute(poll_query, (board_id,))
    cur.execute(poll_board_query, (board_id,))
    cur.execute(board_query, (board_id,))
    db.commit()

    # Get the list of boards
    query = "SELECT * FROM board"
    boards = [dict(b) for b in cur.execute(query).fetchall()]

    # Render the boards list again
    r = make_response(render_template("boards-list.html", boards=boards))
    notification = '{"notification": "Board deleted!"}'
    r.headers.set("HX-Trigger", notification)
    return r
