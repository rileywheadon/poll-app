# NOTE: General functions for working with and viewing polls

from datetime import datetime, timedelta
import time
from flask import Blueprint, url_for, session, redirect
from flask import make_response, render_template, request

import polll.responses as response_handlers
import polll.results as result_handlers

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.utils import url_to_id
from polll.models import delete_poll, query_poll_details, query_comment_details

# Create a blueprint for answering anonymous polls
poll = Blueprint('poll', __name__, template_folder='templates')


@poll.route("/poll/<poll_code>")
def anonymous(poll_code):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Recover the poll ID, query the database
    poll_id = url_to_id(poll_code)
    poll = query_poll_details(poll_id)
    return render_template("anonymous/poll.html", poll=poll, session=session)


@poll.route("/poll/delete/<poll_id>")
def delete(poll_id):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Check that the user is allowed to delete the poll
    res = cur.execute("SELECT * FROM poll WHERE id=?", (poll_id,))
    poll = dict(res.fetchone())
    is_creator = session["user"]["id"] == poll["creator_id"]
    is_admin = session["user"]["email"] == "admin@polll.org"

    # If user is not poll creator or admin, return without deleting the poll
    if (not is_creator) and (not is_admin):
        return ""

    # Delete the poll and all comments
    delete_poll(poll_id)

    # Send a notification to the user
    r = make_response("")
    notification = '{"notification": "Poll Deleted!"}'
    r.headers.set("HX-Trigger", notification)
    return r


@poll.route("/poll/toggle/<poll_id>/<active>")
def toggle(poll_id, active):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Check that the user is allowed to interact with the poll
    res = cur.execute("SELECT * FROM poll WHERE id=?", (poll_id,))
    poll = dict(res.fetchone())
    is_creator = session["user"]["id"] == poll["creator_id"]
    is_admin = session["user"]["email"] == "admin@polll.org"

    # If user is not poll creator or admin, return without deleting the poll
    if (not is_creator) and (not is_admin):
        return ""

    # Update the state of is_active depending on active
    query = """
    UPDATE poll
    SET is_active = ?
    WHERE id = ?
    """
    next_active = 0 if int(active) == 1 else 1
    cur.execute(query, (next_active, poll_id))
    db.commit()

    # Update the poll object
    poll["is_active"] = next_active

    # Add a notification and send the response
    message = '"Poll Closed!"' if next_active == 0 else '"Poll Opened!"'
    notification = f'{{"notification": {message}}}'
    r = make_response(render_template("results/poll-lock.html", poll=poll))
    r.headers.set("HX-Trigger", notification)
    return r


@poll.route("/poll/comment/<poll_id>", methods=["GET", "POST"])
def comment(poll_id):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # If the comment is empty, send an error
    comment = request.form.get("comment")
    if not comment:
        notification = '{"notification": "Comment cannot be empty!"}'
        r = make_response("")
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", "none")
        return r

    # Insert the new comment into the database
    # NOTE: Set parent_id = 0 because Javscript doesn't play nice with null values
    query = """
    INSERT INTO comment (parent_id, poll_id, user_id, comment, timestamp)
    VALUES (0, ?, ?, ?, ?) RETURNING id
    """
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    user_id = session["user"]["id"]
    res = cur.execute(query, (poll_id, user_id, comment, timestamp)).fetchone()
    db.commit()

    # Redirect to the comments endpoint to render the comments
    comment = query_comment_details(res["id"])
    poll = query_poll_details(poll_id)
    return render_template("results/comment-response.html", poll=poll, comment=comment)
