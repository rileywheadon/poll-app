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


# Landing page for advertising to potential users
@home.route("/")
def index():
    return render_template("index.html")


# Route for updating settings (just username at the moment)
@home.route("/home/settings")
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


# Home page (poll feed)
@home.route("/home/feed")
@requires_auth
def feed():

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Query the database for all polls that meet the following conditions:
    #  1. NOT made by the user
    #  2. NOT responded to by the user
    #  3. NOT reported by the user
    #  4. ARE active (i.e. is_active = 1)
    id_query = """
    SELECT id
    FROM poll
    WHERE creator_id != ? AND is_active = 1
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
    res = cur.execute(id_query, (user_id, user_id, user_id))
    ids = [response["id"] for response in res.fetchall()]

    # Query for getting the polls and the creator's username
    poll_query = """
    SELECT poll.*, user.username AS creator
    FROM poll
    INNER JOIN user ON user.id = poll.creator_id
    WHERE poll.id = ?
    """

    # Query for getting the number of responses for each poll
    response_query = """
    SELECT COUNT(*) AS votes
    FROM response
    WHERE poll_id = ?
    """

    # Query for adding the answers to each poll
    answer_query = """
    SELECT *
    FROM poll_answer
    WHERE poll_id = ?
    ORDER BY RANDOM()
    """
    polls = []

    # Iterate through the poll IDs, getting the polls, responses and answers
    for id in ids:

        # Get the poll
        poll = dict(cur.execute(poll_query, (id,)).fetchone())

        # Get the number of responses to the poll
        responses = dict(cur.execute(response_query, (id,)).fetchone())
        poll["votes"] = responses["votes"]

        # Get the poll answers and the template URL
        answers = cur.execute(answer_query, (id,)).fetchall()
        poll["answers"] = [dict(answer) for answer in answers]

        # Get the template, custom URL, and timedelta
        poll["poll_template"] = poll_template(poll)
        poll["url"] = id_to_url(poll["id"])
        poll["age"] = get_poll_age(poll)
        polls.append(poll)

    # Render the template
    session["admin"] = False
    session["tab"] = "feed"
    return render_template("home/feed.html", session=session, polls=polls)


# Home page (poll feed)
@home.route("/home/report/<poll_id>", methods=["GET", "POST"])
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
@home.route("/home/history")
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

    # Get the polls themselves
    query = """
    SELECT poll.*, user.username AS creator
    FROM poll
    INNER JOIN user ON user.id = poll.creator_id
    WHERE poll.id = ?
    """
    polls = []
    for id in ids:

        # Get the poll
        res = cur.execute(query, (id,))
        poll = dict(res.fetchone())

        # Get the results and the result template URL
        handler = getattr(result_handlers, poll["poll_type"].lower())
        poll["results"] = handler(poll["id"])
        poll["result_template"] = result_template(poll)
        polls.append(poll)

    # Render the template
    session["admin"] = False
    session["tab"] = "history"
    return render_template("home/history.html", session=session, polls=polls)


# Home page (create poll)
@home.route("/home/create")
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

    # Render the HTML template
    session["admin"] = False
    session["tab"] = "create"
    return render_template("home/create.html", session=session, on_cooldown=cooldown)


# Create a new poll answer entry box
@home.route("/home/create/answer")
@requires_auth
def create_answer():
    return render_template("home/create-answer.html")


# Create a new poll
@home.route("/home/create/poll")
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
    poll = cur.execute(query, values)

    # Add the poll answers to the database unless they are numeric
    if poll_type not in ["NUMERIC_STAR", "NUMERIC_SCALE"]:

        poll_id = poll.fetchone()["id"]
        columns = "(poll_id, answer)"

        query = """
        INSERT INTO poll_answer (poll_id, answer)
        VALUES (?, ?)
        """

        for answer in answers:
            values = (poll_id, answer)
            cur.execute(query, values)

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

    # Render the create.html template, while triggering a notification
    cooldown = on_cooldown(session["user"])
    r = make_response(render_template(
        "home/create-card.html",
        session=session,
        on_cooldown=cooldown
    ))
    notification = '{"notification": "Poll Submitted!"}'
    r.headers.set("HX-Trigger", notification)
    return r


# Home page (user's polls)
@home.route("/home/mypolls")
@requires_auth
def mypolls():

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Query the database for all polls made by the user
    query = """
    SELECT *
    FROM poll 
    WHERE creator_id = ?
    """
    res = cur.execute(query, (session["user"]["id"],)).fetchall()

    # Create a dictionary of polls
    polls = [dict(poll) for poll in res]

    # Get the results for each poll using the appropriate handler
    for poll in polls:
        handler = getattr(result_handlers, poll["poll_type"].lower())
        poll["results"] = handler(poll["id"])
        poll["result_template"] = result_template(poll)

    # Render the HTML template
    session["admin"] = False
    session["tab"] = "mypolls"
    return render_template("home/mypolls.html", session=session, polls=polls)


# HTTP endpoint for responding to polls
@home.route("/home/response/<poll_id>", methods=["GET", "POST"])
@requires_auth
def response(poll_id):

    # Open the database connection
    db = get_db()
    cur = db.cursor()

    # Check that the user has not already responded to this poll
    response_query = """
    SELECT *
    FROM response
    WHERE user_id = ? AND poll_id =?
    """
    res = cur.execute(response_query, (session["user"]["id"], poll_id))

    # If the user already responded, just render the results
    if res.fetchone() != None:
        return redirect(url_for("home.result", poll_id=poll_id))

    # Otherwise get the poll in the response header
    poll_query = """
    SELECT *
    FROM poll
    WHERE id = ?
    """
    res = cur.execute(poll_query, (poll_id,))
    poll = dict(res.fetchone())

    # Submit the response to the database
    handler = getattr(response_handlers, poll["poll_type"].lower())
    handler(request, poll)

    # Redirect to results to render the results
    return redirect(url_for("home.result", poll_id=poll_id))


# HTTP endpoint for refreshing the results
@home.route("/home/result/<poll_id>", methods=["GET", "POST"])
@requires_auth
def result(poll_id):

    # Open the database connection
    db = get_db()
    cur = db.cursor()

    # Query the poll in the response header
    query = """
    SELECT *
    FROM poll
    WHERE id = ?
    """

    res = cur.execute(query, (poll_id,))
    poll = dict(res.fetchone())

    # Get the results (dependent on the poll type) and render them
    handler = getattr(result_handlers, poll["poll_type"].lower())
    poll["results"] = handler(poll_id)
    poll["result_template"] = result_template(poll)
    return render_template(poll["result_template"], poll=poll)
