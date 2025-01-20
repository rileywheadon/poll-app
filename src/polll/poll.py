# NOTE: General functions for working with and viewing polls

from datetime import datetime, timedelta
import time
from flask import Blueprint, url_for, session, redirect
from flask import make_response, render_template, request

import polll.responses as response_handlers
import polll.results as result_handlers

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import url_to_id, query_poll_details, query_comment_details

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

    # Delete all comments and likes
    comment_query = """
    DELETE FROM comment
    WHERE poll_id = ?
    """

    # Delete all likes/dislikes on all comments
    secondary_comment_query = """
    DELETE FROM {table}
    WHERE id IN (
        SELECT id
        FROM comment
        WHERE comment.poll_id = ?
    )
    """

    # Execute the queries in reverse order
    query = secondary_comment_query.format(table="like")
    cur.execute(query, (poll_id,))
    query = secondary_comment_query.format(table="dislike")
    cur.execute(query, (poll_id,))
    cur.execute(comment_query, (poll_id,))

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
    query = """
    INSERT INTO comment (parent_id, poll_id, user_id, comment, timestamp) 
    VALUES (0, ?, ?, ?, ?)
    """
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    cur.execute(query, (poll_id, session["user"]["id"], comment, timestamp))
    db.commit()

    # Redirect to the comments endpoint to render the comments
    poll = query_poll_details(poll_id)
    return render_template("results/poll-comments.html", poll=poll)


@poll.route("/poll/like/<comment_id>", methods=["GET", "POST"])
def like(comment_id):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Check if the user has already liked or disliked this comment
    like_query = "SELECT * FROM like WHERE comment_id=? AND user_id=?"
    dislike_query = "SELECT * FROM dislike WHERE comment_id=? AND user_id=?"
    user_id = session["user"]["id"]
    like = cur.execute(like_query, (comment_id, user_id)).fetchone()
    dislike = cur.execute(dislike_query, (comment_id, user_id)).fetchone()

    # If the user has already liked the comment, remove the like
    if (not dislike) and like:
        query = "DELETE FROM like WHERE user_id=? AND comment_id=?"
        cur.execute(query, (session["user"]["id"], comment_id))

    # If the user has not liked or disliked the comment, add a like
    if (not dislike) and (not like):
        query = "INSERT INTO like (user_id, comment_id, timestamp) VALUES (?, ?, ?)"
        timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        cur.execute(query, (session["user"]["id"], comment_id, timestamp))

    # Get information about the comment and re-render its template
    db.commit()
    comment = query_comment_details(comment_id)

    # If the commment is a reply, render the reply template
    if comment["parent_id"] != 0:
        return render_template("results/reply.html", reply=comment)

    # Otherwise render the comment template
    return render_template("results/comment.html", comment=comment)


@poll.route("/poll/dislike/<comment_id>", methods=["GET", "POST"])
def dislike(comment_id):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Check if the user has already liked or disliked this comment
    like_query = "SELECT * FROM like WHERE comment_id=? AND user_id=?"
    dislike_query = "SELECT * FROM dislike WHERE comment_id=? AND user_id=?"
    user_id = session["user"]["id"]
    like = cur.execute(like_query, (comment_id, user_id)).fetchone()
    dislike = cur.execute(dislike_query, (comment_id, user_id)).fetchone()

    # If the user has already liked the comment, remove the like
    if (not like) and dislike:
        query = "DELETE FROM dislike WHERE user_id=? AND comment_id=?"
        cur.execute(query, (session["user"]["id"], comment_id))

    # If the user has not liked or disliked the comment, add a like
    if (not like) and (not dislike):
        query = "INSERT INTO dislike (user_id, comment_id, timestamp) VALUES (?, ?, ?)"
        timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        cur.execute(query, (session["user"]["id"], comment_id, timestamp))

    # Get information about the comment and re-render its template
    db.commit()
    comment = query_comment_details(comment_id)

    # If the commment is a reply, render the reply template
    if comment["parent_id"] != 0:
        return render_template("results/reply.html", reply=comment)

    # Otherwise render the comment template
    return render_template("results/comment.html", comment=comment)


@poll.route("/poll/reply/<comment_id>", methods=["GET", "POST"])
def reply(comment_id):

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the poll_id from the database
    query = "SELECT poll_id FROM comment WHERE id=?"
    poll_id = cur.execute(query, (comment_id,)).fetchone()["poll_id"]

    # Insert the reply into the database
    query = """
    INSERT INTO comment (poll_id, user_id, parent_id, comment, timestamp)
    VALUES (?, ?, ?, ?, ?)
    """
    user_id = session["user"]["id"]
    reply = request.form.get("reply")
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    cur.execute(query, (poll_id, user_id, comment_id, reply, timestamp))

    # Update the comment's information and render it again
    db.commit()
    comment = query_comment_details(comment_id)
    return render_template("results/comment.html", comment=comment)
