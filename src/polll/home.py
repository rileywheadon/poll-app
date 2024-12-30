from datetime import datetime, timedelta
import time
from flask import Blueprint, url_for, session, redirect, render_template, request

import polll.responses as response_handlers
import polll.results as result_handlers

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import on_cooldown, result_template, poll_template

# Create a blueprint for the poll endpoints
home = Blueprint('home', __name__, template_folder='templates')


# Landing page for advertising to potential users
@home.route("/")
def index():
    return render_template("index.html")


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
    id_query = """
    SELECT id
    FROM poll
    WHERE poll.creator_id != ?
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
    print(ids)

    # Query for getting the polls and the creator's username
    poll_query = """
    SELECT poll.*, user.username AS creator
    FROM poll
    INNER JOIN user ON user.id = poll.creator_id
    WHERE poll.id = ?
    """

    # Query for adding the answers to each poll
    answer_query = """
    SELECT *
    FROM poll_answer
    WHERE poll_id = ?
    """
    polls = []

    # Iterate through the poll IDs, getting the polls and answers
    for id in ids:

        # Get the poll
        poll = dict(cur.execute(poll_query, (id,)).fetchone())
        print(poll)

        # Get the poll answers and the template URL
        answers = cur.execute(answer_query, (id,)).fetchall()
        poll["answers"] = [dict(answer) for answer in answers]
        poll["poll_template"] = poll_template(poll)
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
    return ""


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
    SELECT *
    FROM poll
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
    answers = request.args.getlist("poll_answer")

    # Log the request information
    print(f"Inserting Poll: ({poll_type}, {question}, {answers})")

    # Add the poll to the database
    columns = "(creator_id, question, poll_type, date_created)"
    values = (creator_id, question, poll_type, date_created)
    query = f"INSERT INTO poll {columns} VALUES (?, ?, ?, ?) RETURNING id"
    poll = cur.execute(query, values)

    # Add the poll answers to the database
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

    # Update the current user's information in the session
    session["user"]["last_poll_created"] = last_poll_created
    session["user"]["next_poll_allowed"] = next_poll_allowed

    # Commit to the database and render the create.html template
    db.commit()
    cooldown = on_cooldown(session["user"])
    return render_template("home/create-card.html", session=session, on_cooldown=cooldown)


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

    # Query the poll in the response header
    query = """
    SELECT *
    FROM poll
    WHERE id = ?
    """

    res = cur.execute(query, (poll_id,))
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
