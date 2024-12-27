from datetime import datetime, timedelta
import time
from flask import Blueprint, url_for, session, redirect, render_template, request

import polll.responses as response_handlers
import polll.results as result_handlers

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import on_cooldown

# Create a blueprint for the poll endpoints
poll = Blueprint('poll', __name__, template_folder = 'templates')

# Landing page for advertising to potential users
@poll.route("/")
def index():
    return render_template("index.html")


# Home page (empty)
@poll.route("/home")
def home(): 
    return render_template("home/home.html", user = session["user"], admin = False)


# Home page (poll feed)
@poll.route("/home/feed")
@requires_auth
def feed():

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Query the database for all polls NOT made by the user
    query = """
    SELECT *
    FROM poll 
    WHERE creator_id != ?
    """
    res = cur.execute(query, (session["user"]["id"],)).fetchall()

    # Create a dictionary of polls 
    polls = [dict(poll) for poll in res]

    # Add the answers to each poll
    query = """
    SELECT *
    FROM poll_answer
    WHERE poll_id = ?
    """
    for poll in polls:
        poll["answers"] = cur.execute(query, (poll["id"],)).fetchall()

    # Render the template
    return render_template(
        "home/feed.html", 
        user = session["user"], 
        polls = polls,
        tab = 'feed'
    )


# Home page (response history)
@poll.route("/home/history")
@requires_auth
def history():

    # Get the database connection
    db = get_db()
    cur = db.cursor()

    # Query the database for all polls NOT made by the user
    query = """
    SELECT *
    FROM poll 
    WHERE creator_id != ?
    """
    res = cur.execute(query, (session["user"]["id"],)).fetchall()

    # Create a dictionary of polls 
    polls = [dict(poll) for poll in res]

    # Render the template
    return render_template(
        "home/history.html", 
        user = session["user"], 
        polls = polls,
        tab = 'history'
    )


# Home page (create poll)
@poll.route("/home/create")
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

    # Render the HTML template
    return render_template(
        "home/create.html", 
        user = session["user"], 
        on_cooldown = on_cooldown(user),
        tab = 'create',
    )


# Create a new poll answer entry box 
@poll.route("/home/create/answer")
@requires_auth
def create_answer():
    return render_template("home/create-answer.html")


# Create a new poll
@poll.route("/home/create/poll")
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
    poll_id = poll.fetchone()["id"]
    columns = "(poll_id, answer)"
    for answer in answers:
        values = (poll_id, answer)
        cur.execute(f"INSERT INTO poll_answer {columns} VALUES (?, ?)", values)

    # Update the last poll created time for the user
    id = session["user"]["id"]
    last_poll_time = datetime.utcnow()
    next_poll_time = last_poll_time

    # If user is not the administrator, increment next_poll_allowed by one day
    if session["user"]["email"] != "admin@polll.org":
        next_poll_time += timedelta(days = 1)

    # Update the current user's information in the database
    last_poll_created = last_poll_time.strftime('%Y-%m-%d %H:%M:%S')
    next_poll_allowed = next_poll_time.strftime('%Y-%m-%d %H:%M:%S')
    values = (last_poll_created, next_poll_allowed, creator_id)
    query = f"UPDATE user SET last_poll_created = ?, next_poll_allowed = ? WHERE id=?"
    cur.execute(query, values)

    # Update the current user's information in the session
    session["user"]["last_poll_created"] = last_poll_created
    session["user"]["next_poll_allowed"] = next_poll_allowed

    # Commit to the database and render the create.html template
    db.commit()
    return redirect(url_for("poll.create")) 


# Home page (user's polls)
@poll.route("/home/mypolls")
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

    # Add the answers to each poll
    query = """
    SELECT *
    FROM poll_answer
    WHERE poll_id = ?
    """
    for poll in polls:
        poll["answers"] = cur.execute(query, (poll["id"],)).fetchall()

    # Render the template
    return render_template(
        "home/mypolls.html", 
        user = session["user"], 
        polls = polls,
        tab = 'mypolls'
    )


# HTTP endpoint for responding to polls
@poll.route("/home/response/<poll_id>", methods=["GET", "POST"])
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
    if poll["poll_type"] == "CHOOSE_ONE":
        response_handlers.choose_one(request, poll)
    if poll["poll_type"] == "CHOOSE_MANY":
        response_handlers.choose_many(request, poll)
    if poll["poll_type"] == "NUMERIC_STAR":
        response_handlers.numeric_star(request, poll)
    if poll["poll_type"] == "NUMERIC_SCALE":
        response_handlers.numeric_scale(request, poll)
    if poll["poll_type"] == "RANKED_POLL":
        response_handlers.ranked_poll(request, poll)
    if poll["poll_type"] == "TIER_LIST":
        response_handlers.tier_list(request, poll)

    # Redirect to results to render the results
    return redirect(url_for("poll.result", poll_id = poll_id))


# HTTP endpoint for refreshing the results
@poll.route("/home/result/<poll_id>", methods=["GET", "POST"])
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
    if poll["poll_type"] == "CHOOSE_ONE":
        results = result_handlers.choose_one(poll_id)
        return render_template("results/choose-one.html", poll=poll, results=results)

    if poll["poll_type"] == "CHOOSE_MANY":
        results = result_handlers.choose_many(poll_id)
        return render_template("results/choose-many.html", poll=poll, results=results)

    if poll["poll_type"] == "NUMERIC_STAR":
        results = result_handlers.numeric_star(poll_id)
        return render_template("results/numeric-star.html", poll=poll, results=results)

    if poll["poll_type"] == "NUMERIC_SCALE":
        results = result_handlers.numeric_scale(poll_id)
        return render_template("results/numeric-scale.html", poll=poll, results=results)

    if poll["poll_type"] == "RANKED_POLL":
        results = result_handlers.ranked_poll(poll_id)
        return render_template("results/ranked-poll.html", poll=poll, results=results)

    if poll["poll_type"] == "TIER_LIST":
        results = result_handlers.tier_list(poll_id)
        return render_template("results/tier-list.html", poll=poll, results=results)

    # This should never happen
    return redirect(url_for("home"))



