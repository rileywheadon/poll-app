from flask import request, session
from datetime import datetime, timedelta
from polll.db import get_db
import polll.results as result_handlers
import polll.responses as response_handlers
import base64


# Helper function to check if a user is on cooldown from making a poll
def on_cooldown(user_dict):

    next_poll_allowed = user_dict["next_poll_allowed"]

    if next_poll_allowed:

        next_poll_time = datetime.strptime(
            next_poll_allowed,
            '%Y-%m-%d %H:%M:%S'
        )

        return datetime.utcnow() < next_poll_time

    return False


# Get the age of a poll (i.e. 2h or 4d)
def get_poll_age(poll):
    timestamp = datetime.strptime(poll["date_created"], '%Y-%m-%d %H:%M:%S')
    age = datetime.utcnow() - timestamp

    if age.days > 0:
        return f"{age.days}d"
    elif age.seconds // 3600 > 0:
        return f"{age.seconds // 3600}h"
    elif age.seconds // 60 > 0:
        return f"{age.seconds // 60}m"
    else:
        return f"{age.seconds}s"


# Helper functions to add "result_template" and "poll_template" to a poll dictionary
def result_template(poll):
    template = poll["poll_type"].lower().replace("_", "-")
    return f"results/{template}.html"


def poll_template(poll):
    template = poll["poll_type"].lower().replace("_", "-")
    return f"polls/{template}.html"


# Helper function to get days behind current time
def get_days_behind(days):
    time = datetime.utcnow() - timedelta(days=days)
    return datetime.strftime(time, '%Y-%m-%d %H:%M:%S')


# Helper functions to encode/decode a poll ID as a URL string
def id_to_url(n):
    hash = ((0x0000FFFF & n) << 16) + ((0xFFFF0000 & n) >> 16)
    code = base64.urlsafe_b64encode(str(hash).encode()).decode()
    return f"{request.scheme}://{request.host}/poll/{code}"


def url_to_id(code):
    hash = int(base64.urlsafe_b64decode(code.encode()).decode())
    return ((0x0000FFFF & hash) << 16) + ((0xFFFF0000 & hash) >> 16)


# Helper function to get how "trendy" a poll is, in responses/second
def popularity(poll):
    timestamp = datetime.strptime(poll["date_created"], '%Y-%m-%d %H:%M:%S')
    age = (datetime.utcnow() - timestamp).total_seconds()
    return poll["votes"] / age


# Given a poll ID, gets all useful information including:
#  - Poll age using get_poll_age
#  - Number of votes on the poll
#  - All poll answers (just the text)
#  - The custom poll URL

# NOTE: Does not get the results of the poll (see results.py)
def query_poll_details(id, user=None):

    # Query for getting the poll data along with the creator's username
    poll_query = """
    SELECT poll.*, user.username AS creator
    FROM poll
    INNER JOIN user ON user.id = poll.creator_id
    WHERE poll.id = ?
    """

    # Query for getting the number of responses for the poll
    response_query = """
    SELECT COUNT(*) AS votes
    FROM response
    WHERE poll_id = ?
    """

    # Query for adding the answers data to each poll
    answer_query = """
    SELECT *
    FROM poll_answer
    WHERE poll_id = ?
    ORDER BY RANDOM()
    """

    # Open a database connection
    db = get_db()
    cur = db.cursor()

    # Get the poll
    poll = dict(cur.execute(poll_query, (id,)).fetchone())

    # Get the number of responses to the poll
    responses = dict(cur.execute(response_query, (id,)).fetchone())
    poll["votes"] = responses["votes"]

    # Get the poll answers and the template URL
    answers = cur.execute(answer_query, (id,)).fetchall()
    poll["answers"] = [dict(answer) for answer in answers]

    # Get the results using the appropriate result handler
    handler = getattr(result_handlers, poll["poll_type"].lower())
    poll["results"], poll["response"] = handler(poll["id"], user)
    poll["result_template"] = result_template(poll)

    # Get the template, custom URL, and timedelta
    poll["poll_template"] = poll_template(poll)
    poll["url"] = id_to_url(poll["id"])
    poll["age"] = get_poll_age(poll)

    # Return the populated poll dictionary
    return poll


# If the user has not already responded, add the response to the database
def validate_response(form, poll_id):

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

    # If the user already responded, return
    if res.fetchone() != None:
        return

    # Otherwise get the poll in the response header
    poll_query = """
    SELECT id
    FROM poll
    WHERE id=?
    """
    res = cur.execute(poll_query, (poll_id,))
    poll = query_poll_details(poll_id)

    # Submit the response to the database
    handler = getattr(response_handlers, poll["poll_type"].lower())
    handler(form, poll)
