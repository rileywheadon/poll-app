# NOTE: General functions for working with and viewing polls

from datetime import datetime, timedelta
import time
from flask import Blueprint, url_for, session, redirect
from flask import make_response, render_template, request

import polll.responses as response_handlers
import polll.results as result_handlers

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import url_to_id, poll_template, query_poll_details

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
    return render_template("anonymous/poll.html", poll=poll)


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

    # Delete the poll
    poll_query = """
    DELETE FROM poll
    WHERE poll.id = ?
    """

    # Delete the poll/board equivalencies
    poll_board_query = """
    DELETE FROM poll_board
    WHERE poll_id = ?
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
    for table in secondary_tables:
        query = secondary_response_query.format(table=table)
        cur.execute(query, (poll_id,))

    cur.execute(response_query, (poll_id,))
    cur.execute(answer_query, (poll_id,))
    cur.execute(poll_board_query, (poll_id,))
    cur.execute(poll_query, (poll_id,))
    db.commit()

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
