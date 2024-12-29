from flask import Blueprint, render_template, redirect, url_for, request, session
from datetime import datetime, timedelta
import requests

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import on_cooldown, get_days_behind

admin = Blueprint('admin', __name__, template_folder = 'templates/admin')


@admin.route("/admin/users")
@requires_admin
def users():



    session["admin"] = True
    session["tab"] = "users"
    return render_template("users.html", session=session) 


@admin.route("/admin/users/usersearch")
@requires_admin
def usersearch():

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the headers from the HTTP request
    column = request.args.get("search_column")
    value = "%{}%".format(request.args.get("search_value"))

    # Check that the search column is valid to prevent SQL injection
    if column not in ["username", "email"]: return ""

    # Query the database for all users matching the search
    query = f"""
    SELECT *
    FROM user
    WHERE {column}
    LIKE ?
    """
    res = cur.execute(query, (value,))
    users = [dict(row) for row in res.fetchall()]

    # If there are no users, just return nothing
    if not users: return ""

    # Update the cooldown state for each user
    for user in users: user["on_cooldown"] = on_cooldown(user)
    return render_template("users-list.html", users=users)


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


    session["admin"] = True
    session["tab"] = "polls"
    return render_template("polls.html", session=session) 


@admin.route("/admin/pollsearch", methods=["GET", "POST"])
@requires_admin
def pollsearch():

    # Get a db connection
    db = get_db()
    cur = db.cursor()

    # Get the request data
    column = request.form.get("search_column")
    value = "%{}%".format(request.form.get("search_value"))
    sort = request.form.get("search_sort")
    direction = request.form.get("search_sort_direction")

    # Construct a query for selecting the poll types
    types = tuple(request.form.getlist("search_type"))
    type_query = " OR ".join([f"poll.poll_type = '{t}'" for t in types])

    # If no poll types selected, get all the poll types
    if type_query == "": type_query = "True"

    # Check column, sort, direction are valid to avoid SQL injection
    if column not in ["creator", "question"]: return ""
    if sort not in ["date_created"]: return ""
    if direction not in ["DESC", "ASC"]: return ""

    # Create the query and build the values tuple
    poll_query = f"""
    SELECT poll.*, user.username AS creator, user.email AS creator_email
    FROM poll
    INNER JOIN user ON user.id = poll.creator_id
    WHERE ({column} LIKE ?) AND ({type_query})
    ORDER BY {sort} {direction}
    """
    res = cur.execute(poll_query, (value,))
    polls = [dict(poll) for poll in res.fetchall()]

    # Add the answers to the poll, if they exist
    answer_query = """
    SELECT * 
    FROM poll_answer
    WHERE poll_answer.poll_id = ?
    """
    for poll in polls:
        res = cur.execute(answer_query, (poll["id"],))
        poll["answers"] = [dict(answer) for answer in res.fetchall()]

    print(polls)
    return render_template("admin/polls-list.html", polls=polls)


@admin.route("/admin/polldelete/<poll_id>")
@requires_admin
def polldelete(poll_id):

    # Delete the poll
    poll_query = """
    DELETE FROM poll
    WHERE poll.id = ?
    """

    # Delete the poll answers (if they exist)
    answer_query = """
    DELETE FROM poll_answer
    WHERE poll_answer.poll_id = ?
    """

    # Delete the responses (if they exist)
    response_query = """
    DELETE FROM response
    WHERE response.poll_id = ?
    """

    # Delete the secondary response rows (if they exist)
    secondary_response_query = """
    DELETE FROM {table}
    WHERE response_id IN (
        SELECT {table}.response_id FROM {table}
        INNER JOIN response ON response.id = {table}.response_id
        WHERE response.poll_id = ?
    )
    """
    secondary_tables = [
        "empty_response", 
        "discrete_response", 
        "numeric_response",
        "ranked_response",
        "tiered_response"
    ]

    # Execute the queries in reverse order
    db = get_db()
    cur = db.cursor()

    for table in secondary_tables:
        query = secondary_response_query.format(table = table)
        print(query)
        cur.execute(query, (poll_id,))

    cur.execute(response_query, (poll_id,))
    cur.execute(answer_query, (poll_id,))
    cur.execute(poll_query, (poll_id,))
    db.commit()
    return ""


@admin.route("/admin/reports")
@requires_admin
def reports():

    session["admin"] = True
    session["tab"] = "reports"
    return render_template("reports.html", session=session) 


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
    count = lambda q, d : dict(cur.execute(q, (d,)).fetchone())["count"]
    for day in days:
        stats["responses"].append(count(response_query, day))
        stats["polls"].append(count(poll_query, day))

    session["admin"] = True
    session["tab"] = "stats"
    return render_template("stats.html", session=session, stats=stats)




