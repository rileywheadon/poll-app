from datetime import datetime, timedelta
import time
from flask import Blueprint, url_for, session, redirect, render_template, request

import polll.responses as response_handlers
import polll.results as result_handlers

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import url_to_id, poll_template

# Create a blueprint for answering anonymous polls
poll = Blueprint('poll', __name__, template_folder='templates')


@poll.route("/poll/<poll_code>")
def anonymous(poll_code):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Recover the poll ID, query the database
    poll_id = url_to_id(poll_code)
    poll_query = """
    SELECT poll.*, user.username AS creator
    FROM poll
    INNER JOIN user ON poll.creator_id = user.id
    WHERE poll.id = ?
    """
    poll = dict(cur.execute(poll_query, (poll_id,)).fetchone())

    # Add any poll answers to the poll
    answer_query = """
    SELECT *
    FROM poll_answer
    WHERE poll_id = ?
    """
    res = cur.execute(answer_query, (poll_id,)).fetchall()
    poll["answers"] = [dict(answer) for answer in res]

    # Render the poll in a new tab
    poll["poll_template"] = poll_template(poll)
    return render_template("anonymous.html", poll=poll)
