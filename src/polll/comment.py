# NOTE: General functions for working with and viewing comments

from datetime import datetime, timedelta
import time
from flask import Blueprint, url_for, session, redirect
from flask import make_response, render_template, request

import polll.responses as response_handlers
import polll.results as result_handlers

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.utils import *
from polll.models import url_to_id, query_poll_details, query_comment_details

# Create a blueprint for answering anonymous polls
comment = Blueprint('comment', __name__, template_folder='templates')


# Endpoint for both liking and disliking comments
@comment.route("/comment/like/<comment_id>/<action>", methods=["GET", "POST"])
def like(comment_id, action):

    db = get_db()
    user = session["user"]
    user_id = user["id"]

    # Find the comment by checking the comments and replies
    comment = None
    comment_id = int(comment_id)
    if comment_id in session["comments"]:
        comment = session["comments"][comment_id]
    else:
        comment = session["replies"][comment_id]

    # Determine if the user has liked or disliked this comment
    table = None
    if comment_id in session["user"]["likes"]:
        table = "like"
    if comment_id in session["user"]["dislikes"]:
        table = "dislike"

    # If the user has liked or disliked this comment, remove it
    if table:
        
        # Delete the existing like/dislike from the database
        res = (
            db.table(table)
            .delete()
            .eq("comment_id", comment_id)
            .eq("user_id", user_id)
            .execute()
        )

        # Delete the existing like/dislike from the cache, update the count
        user[f"{table}s"].remove(comment_id)
        comment[f"{table}_count"] -= 1

    # If the user's previous action does not equal their current one, execute it
    if table != action:

        # Add a new like/dislike to the database
        res = db.table(action).insert({
            "user_id": user_id,
            "comment_id": comment_id
        }).execute()

        # Add a new like/dislike to the cache, update the count
        user[f"{action}s"].append(comment_id)
        comment[f"{action}_count"] += 1

    # Get information about the comment and re-render its template
    session["user"] = user
    session.modified = True
    return render_template("results/comment-like.html", session=session, comment=comment)

# Endpoint for loading the replies to a comment
@comment.route("/comment/replies/<comment_id>")
def replies(comment_id):

    # Get all of the replies to this comment
    db = get_db()
    res = (
        db.table("comment")
        .select("*", "like(count)","dislike(count)","user(*)")
        .eq("parent_id", comment_id)
        .order("created_at", desc=True)
        .execute()
    )

    # Populate the list of replies with the additional data, update the cached comments
    del session["replies"]
    session["replies"] = {c["id"]: query_comment_details(c) for c in res.data}
    comment = session["comments"][int(comment_id)]
    session.modified = True

    # Render the response template 
    return render_template(
        "results/responses/get-reply-response.html",
        session=session
    )


# Endpoint for creating a reply to a comment
@comment.route("/comment/create_reply/<comment_id>", methods=["GET", "POST"])
def create_reply(comment_id):

    # Get the poll ID from the parent
    db = get_db()
    comment = session["comments"][int(comment_id)]
    poll_id = comment["poll_id"]

    # If the comment is empty, send an error
    reply = request.form.get("reply")
    if not comment:
        notification = '{"notification": "Reply cannot be empty!"}'
        r = make_response("")
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", "none")
        return r

    # Insert the reply into the database
    res = db.table("comment").insert({
        "poll_id": poll_id,
        "user_id": session["user"]["id"],
        "parent_id": comment_id,
        "comment": reply,
    }).execute()

    # Set additional information on the new reply 
    reply = res.data[0]
    reply["user"] = session["user"]
    reply["age"] = format_timestamp(reply["created_at"])
    reply["like_count"] = 0
    reply["dislike_count"] = 0 
    reply["reply_count"] = 0

    # Update the comment's information and render it again, add the reply to the session
    comment["reply_count"] += 1 
    session["replies"][int(reply["id"])] = reply

    # Slightly less sinful hack to move the new reply to the top of the replies dict
    replies = list(session["replies"].items())
    replies.insert(0, replies.pop()) 
    session["replies"] = dict(replies)

    # Render the response template
    session.modified = True
    return render_template(
        "results/responses/send-reply-response.html",
        session = session,
        comment = comment
    )


# Delete a comment
@comment.route("/comment/delete/<comment_id>", methods=["GET", "POST"])
@requires_auth
def delete(comment_id):

    # Delete the comment
    db = get_db()
    db.table("comment").delete().eq("id", comment_id).execute()
    b = "results/responses/"
    t = None

    # Different behaviour is needed if the comment is a comment or reply
    if int(comment_id) in session["comments"]:

        # Query the database to get the number of comments for the poll
        comment = session["comments"][int(comment_id)]
        poll_id = comment["poll_id"]
        poll = session["polls"][int(poll_id)]
        res = db.table("comment").select("id").eq("poll_id", poll_id).execute()
        poll["comment_count"] = len(res.data)

        # Remove the comment from the session
        del session["comments"][int(comment_id)]

        # Set the correct template
        t = render_template(f"{b}delete-comment.html", poll=poll)

    else:

        print("deleting a reply")

        # Decrement the reply count on the parent comment
        reply = session["replies"][int(comment_id)]
        parent_id = reply["parent_id"]
        comment = session["comments"][int(parent_id)]
        comment["reply_count"] -= 1
        poll_id = comment["poll_id"]
        poll = session["polls"][int(poll_id)]

        # Remove the reply from the session
        del session["replies"][int(comment_id)]

        # Set the correct template
        t = render_template(
            f"{b}delete-reply.html",
            session=session,
            comment=comment,
            poll=poll
        )
    
    r = make_response(t)
    notification = '{"notification": "Comment Deleted!"}'
    r.headers.set("HX-Trigger", notification)
    session.modified = True
    return r

# Report a poll
@comment.route("/comment/report/<comment_id>", methods=["GET", "POST"])
@requires_auth
def report(comment_id):

    # Get the comment from either the comments or replies dictionary
    db = get_db()
    comment = None
    if int(comment_id) in session["comments"]:
        comment = session["comments"][int(comment_id)]
    else:
        comment = session["replies"][int(comment_id)]

    # Insert the report into the database
    db.table("comment_report").insert({ 
        "comment_id": comment_id,
        "receiver_id": comment["user_id"],
        "creator_id": session["user"]["id"]
    }).execute()

    # Return a notification
    r = make_response("")
    notification = '{"notification": "Comment Reported!"}'
    r.headers.set("HX-Trigger", notification)
    return r


