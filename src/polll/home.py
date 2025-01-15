from datetime import datetime, timedelta
import time

from flask import Blueprint, url_for, session, redirect
from flask import render_template, request, make_response

import polll.responses as response_handlers
import polll.results as result_handlers

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import *

# Create a blueprint for the poll endpoints
home = Blueprint('home', __name__, template_folder='templates')


# https://127.0.0.1:3000/poll/MTMxMDcy
# https://127.0.0.1:3000/poll/MjYyMTQ0
# https://127.0.0.1:3000/poll/MzkzMjE2
# https://127.0.0.1:3000/poll/NTI0Mjg4
# https://127.0.0.1:3000/poll/NjU1MzYw


# Landing page for advertising to potential users
@home.route("/")
def index():
    if session.get("responses"):
        print(session["responses"])

    return render_template("index.html")


# Route for updating settings (just username at the moment)
@home.route("/settings")
@requires_auth
def save_settings():

    # Open database connection
    db = get_db()
    cur = db.cursor()

    # Check if the username the user wants is in the database
    username = request.args.get("username")
    res = cur.execute("SELECT * FROM user WHERE username=?", (username,))
    unique = res.fetchone() is None

    # If the username is not different from the current username, return
    if session["user"]["username"] == username:
        return ""

    # If the new username is unique, assign it to the user
    notification = ""
    if unique:
        notification = '{"notification": "Name Changed!"}'
        session["user"]["username"] = username
        id = session["user"]["id"]
        cur.execute("UPDATE user SET username=? WHERE id=?", (username, id))
        db.commit()

    # Otherwise notify the user that an error occured
    else:
        notification = '{"notification": "Name Taken!"}'

    # Send a notification to the user and return
    session.modified = True
    r = make_response("")
    r.headers.set("HX-Trigger", notification)
    return r


# Home page (poll feed). The board/order is optional (set to All/hot by default)
@home.route("/feed")
@requires_auth
def feed():

    # Get the request arguments (board and order)
    board = request.args.get("board") or "All"
    order = request.args.get("order") or "hot"

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Get the board ID
    board_query = "SELECT id FROM board WHERE name=?"
    res = cur.execute(board_query, (board,)).fetchone()
    board_id = dict(res)["id"] if res else "1"

    # Query the database for all polls that meet the following conditions:
    #  1. ARE in the selected board
    #  2. NOT made by the user
    #  3. NOT responded to by the user
    #  4. NOT reported by the user
    #  5. ARE active (i.e. is_active = 1)
    id_query = """
    SELECT poll.id
    FROM poll
    INNER JOIN poll_board ON poll_id=poll.id
    WHERE board_id = ? AND creator_id != ? AND is_active = 1
    EXCEPT SELECT poll_id FROM (
        SELECT DISTINCT poll_id
        FROM response
        WHERE response.user_id = ?
        UNION
        SELECT DISTINCT poll_id
        FROM report
        WHERE report.creator_id = ?
    )
    """
    user_id = session["user"]["id"]
    res = cur.execute(id_query, (board_id, user_id, user_id, user_id))
    ids = [response["id"] for response in res.fetchall()]

    # Iterate through the poll IDs, getting the details
    polls = [query_poll_details(id) for id in ids]

    # Sort the polls based on the provided order
    if order == "hot":
        polls = sorted(polls, key=lambda p: popularity(p), reverse=True)
    if order == "top":
        polls = sorted(polls, key=lambda p: p["votes"], reverse=True)
    if order == "new":
        polls = sorted(polls, key=lambda p: p["date_created"], reverse=True)

    # Get the boards
    query = "SELECT * FROM board"
    boards = [dict(b) for b in cur.execute(query).fetchall()]

    # Render the template
    session["admin"] = False
    session["tab"] = "feed"
    session["board"] = board
    session["feed"] = order
    return render_template("home/feed.html", session=session, polls=polls, boards=boards)


# Home page (poll feed)
@home.route("/report/<poll_id>", methods=["GET", "POST"])
@requires_auth
def report(poll_id):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the ID of the user recieving the poll
    query = "SELECT creator_id FROM poll WHERE id=?"
    res = cur.execute(query, (poll_id,)).fetchone()

    # Get the other required values for the report
    receiver_id = res["creator_id"]
    creator_id = session["user"]["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

    # Execute the insertion query
    query = """
    INSERT INTO report (poll_id, receiver_id, creator_id, timestamp)
    VALUES (?, ?, ?, ?)
    """
    cur.execute(query, (poll_id, receiver_id, creator_id, timestamp))
    db.commit()

    # Remove the poll from the User's feed
    r = make_response("")
    notification = '{"notification": "Poll Reported!"}'
    r.headers.set("HX-Trigger", notification)
    return r


# Home page (response history)
@home.route("/history")
@requires_auth
def history():

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Get all polls IDs from polls the user has repsonded to
    query = """
    SELECT DISTINCT poll_id
    FROM response
    WHERE response.user_id = ?
    """
    res = cur.execute(query, (session["user"]["id"],))
    ids = [response["poll_id"] for response in res.fetchall()]

    # Get the poll details using query_poll_details
    polls = [query_poll_details(id) for id in ids]

    # Render the template
    session["admin"] = False
    session["tab"] = "history"
    return render_template("home/history.html", session=session, polls=polls)


# Home page (create poll)
@home.route("/create")
@requires_auth
def create():

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Get the end of the poll cooldown from the database
    query = """
    SELECT *
    FROM user
    WHERE email=?
    """
    user = cur.execute(query, (session["user"]["email"],)).fetchone()
    cooldown = on_cooldown(user)

    # Get the boards
    query = "SELECT * FROM board"
    boards = [dict(b) for b in cur.execute(query).fetchall()]

    # Set the session variables
    session["admin"] = False
    session["tab"] = "create"
    session["on_cooldown"] = cooldown

    # Render the HTML template
    return render_template("home/create.html", session=session, boards=boards)


# Create a new poll answer entry box
@home.route("/create/answer")
@requires_auth
def create_answer():
    return render_template("home/create-answer.html")


# Create a new poll
@home.route("/create/poll")
@requires_auth
def create_poll():

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Get request data and other information
    creator_id = session["user"]["id"]
    question = request.args.get("poll_question")
    poll_type = request.args.get("poll_type")
    date_created = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    is_anonymous = 1 if request.args.get("poll_anonymous") else 0
    is_active = 1  # Polls are active by default
    answers = request.args.getlist("poll_answer")
    board_ids = request.args.getlist("poll_board")

    # Check that the question and answers are not empty
    numeric = poll_type in ["NUMERIC_STAR", "NUMERIC_SCALE"]
    if question == "" or (any([a == "" for a in answers]) and not numeric):
        r = make_response("")
        notification = '{"notification": "Question/answers cannot be empty!"}'
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", 'none')
        return r

    # Check that the answers do not contain duplicates
    if len(set(answers)) < len(answers) and not numeric:
        r = make_response("")
        notification = '{"notification": "Answers cannot have duplicates!"}'
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", 'none')
        return r

    # Add the poll to the database
    query = """
    INSERT INTO poll (
        creator_id,
        question,
        poll_type,
        date_created,
        is_anonymous,
        is_active
    )
    VALUES (?, ?, ?, ?, ?, ?) RETURNING id
    """
    values = (
        creator_id,
        question,
        poll_type,
        date_created,
        is_anonymous,
        is_active
    )
    poll = cur.execute(query, values).fetchone()

    # Assign the boards to the poll
    for board_id in board_ids:

        query = "INSERT INTO poll_board (poll_id, board_id) VALUES (?, ?)"
        cur.execute(query, (poll["id"], board_id))

    # Add the poll answers to the database unless they are numeric
    if not numeric:

        query = "INSERT INTO poll_answer (poll_id, answer) VALUES (?, ?)"

        for answer in answers:
            cur.execute(query, (poll["id"], answer))

    # Update the last poll created time for the user
    id = session["user"]["id"]
    last_poll_time = datetime.utcnow()
    next_poll_time = last_poll_time

    # If user is not the administrator, increment next_poll_allowed by one day
    if session["user"]["email"] != "admin@polll.org":
        next_poll_time += timedelta(days=1)

    # Update the current user's information in the database
    last_poll_created = last_poll_time.strftime('%Y-%m-%d %H:%M:%S')
    next_poll_allowed = next_poll_time.strftime('%Y-%m-%d %H:%M:%S')
    values = (last_poll_created, next_poll_allowed, creator_id)

    query = """
    UPDATE user
    SET last_poll_created = ?, next_poll_allowed = ?
    WHERE id=?
    """

    cur.execute(query, values)
    db.commit()

    # Update the current user's information in the session
    session["user"]["last_poll_created"] = last_poll_created
    session["user"]["next_poll_allowed"] = next_poll_allowed
    session["on_cooldown"] = on_cooldown(session["user"])

    # Get the boards
    query = "SELECT * FROM board"
    boards = [dict(b) for b in cur.execute(query).fetchall()]

    # Render the create.html template, while triggering a notification
    r = make_response(render_template(
        "home/create-card.html",
        session=session,
        boards=boards
    ))
    notification = '{"notification": "Poll Submitted!"}'
    r.headers.set("HX-Trigger", notification)
    return r


# Home page (user's polls)
@home.route("/mypolls")
@requires_auth
def mypolls():

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Query the database for all polls made by the user
    query = """
    SELECT id
    FROM poll
    WHERE creator_id = ?
    """
    res = cur.execute(query, (session["user"]["id"],))
    ids = [response["id"] for response in res.fetchall()]

    # Iterate through the poll IDs, getting the details
    polls = [query_poll_details(id) for id in ids]

    # Render the HTML template
    session["admin"] = False
    session["tab"] = "mypolls"
    return render_template("home/mypolls.html", session=session, polls=polls)


# HTTP endpoint for responding to polls
@home.route("/response/<poll_id>", methods=["GET", "POST"])
def response(poll_id):

    # If the user is not logged in, add their response to the session variable
    if not session.get("user"):

        # Create a list in the session variable if it doesn't already exist
        if session.get("responses") is None:
            session["responses"] = []

        # If the poll isn't already in the responses, add the user's response
        if not any([r["poll"] == poll_id for r in session["responses"]]):
            response = {
                "form": request.form.to_dict(flat=False),
                "poll": poll_id
            }
            session["responses"].append(response)
            session.modified = True

        return render_template("anonymous/submit.html")

    # Validate the response, then render the results
    validate_response(request.form.to_dict(flat=False), poll_id)
    return redirect(url_for("home.result", poll_id=poll_id))


# HTTP endpoint for refreshing the results
@home.route("/result/<poll_id>", methods=["GET", "POST"])
@requires_auth
def result(poll_id):
    poll = query_poll_details(poll_id)
    return render_template(poll["result_template"], poll=poll)
