# NOTE: General functions for working with and viewing comments

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
comment = Blueprint('comment', __name__, template_folder='templates')


# Endpoint for both liking and disliking comments
@comment.route("/comment/like/<comment_id>/<action>", methods=["GET", "POST"])
def like(comment_id, action):

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
    if like:
        query = "DELETE FROM like WHERE user_id=? AND comment_id=?"
        cur.execute(query, (session["user"]["id"], comment_id))

    # If the user has disliked the comment, remove the dislike
    if dislike:
        query = "DELETE FROM dislike WHERE user_id=? AND comment_id=?"
        cur.execute(query, (session["user"]["id"], comment_id))

    # If the user had not liked the comment before but wants to, add a like
    if (not like) and action == "like":
        query = "INSERT INTO like (user_id, comment_id, timestamp) VALUES (?, ?, ?)"
        timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        cur.execute(query, (session["user"]["id"], comment_id, timestamp))

    # If the user had not disliked the comment before but wants to, add a dislike
    if (not dislike) and action == "dislike":
        query = "INSERT INTO dislike (user_id, comment_id, timestamp) VALUES (?, ?, ?)"
        timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        cur.execute(query, (session["user"]["id"], comment_id, timestamp))

    # Get information about the comment and re-render its template
    db.commit()
    comment = query_comment_details(comment_id)

    # Otherwise render the comment template
    return render_template("results/comment-like.html", comment=comment)


# Endpoint for replying to a comment
@comment.route("/comment/reply/<comment_id>", methods=["GET", "POST"])
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
    return render_template("results/comment-body.html", comment=comment)
