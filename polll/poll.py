# NOTE: General functions for working with and viewing polls

from datetime import datetime, timedelta
import time
import json 
from flask import Blueprint, url_for, session, redirect
from flask import make_response, render_template, request

from .responses import query_response, create_response
from .results import query_results

from .auth import requires_auth, requires_admin
from .db import get_db
from .utils import *


# Create a blueprint for answering anonymous polls
poll = Blueprint('poll', __name__, template_folder='templates')

# Comment limit
COMMENT_LIMIT = 10

@poll.route("/poll/<poll_code>")
def anonymous(poll_code):

    # Get the poll details
    db = get_db()
    poll_id = url_to_id(poll_code)
    res = db.rpc("poll", {"pid": poll_id}).execute()
    poll = query_poll_details(res.data[0])

    # Reset the comments and replies
    del session["comments"]
    del session["replies"]
    session["comments"] = {}
    session["replies"] = {}

    # Add poll to session and render the poll
    session["polls"][str(poll_id)] = poll
    session.modified = True
    return render_template("anonymous/poll.html", session=session, poll=poll)


@poll.route("/poll/delete/<poll_id>")
@requires_auth
def delete(poll_id):

    # Get a database connection and delete the poll
    db = get_db()
    db.table("poll").delete().eq("id", poll_id).execute()
    
    # Send a notification to the user
    r = make_response("")
    notification = '{"notification": "Poll Deleted!"}'
    r.headers.set("HX-Trigger", notification)
    return r


@poll.route("/poll/toggle/<poll_id>/<active_str>")
@requires_auth
def toggle(poll_id, active_str):

    # Update the poll state
    db = get_db()
    active = True if active_str == "True" else False
    db.table("poll").update({"is_active": not active}).eq("id", poll_id).execute()

    # Add a notification and send the response
    message = '"Poll Closed!"' if active else '"Poll Opened!"'
    notification = f'{{"notification": {message}}}'
    t = render_template("results/poll-lock.html", id=poll_id, is_active=not active)
    r = make_response(t)
    r.headers.set("HX-Trigger", notification)
    return r


@poll.route("/poll/pin/<poll_id>/<pinned_str>")
@requires_admin
def pin(poll_id, pinned_str):

    # Update the poll state
    db = get_db()
    pinned = True if pinned_str == "True" else False
    db.table("poll").update({"is_pinned": not pinned}).eq("id", poll_id).execute()

    # Add a notification and send the response
    message = '"Poll Unpinned!"' if pinned else '"Poll Pinned!"'
    notification = f'{{"notification": {message}}}'
    t = render_template("results/poll-pin.html", id=poll_id, is_pinned=not pinned)
    r = make_response(t)
    r.headers.set("HX-Trigger", notification)
    return r


@poll.route("/poll/favourite/<poll_id>/user/<user_id>")
def favourite(poll_id, user_id):

    db = get_db()
    favourite = len(db.table("poll_favourite").select("*").eq("user_id", user_id).eq("poll_id", poll_id).execute().data) == 0
    if favourite:
        favourite_data = [{"user_id": int(user_id), "poll_id": int(poll_id)}]
        db.table("poll_favourite").insert(favourite_data).execute()
    else:
        db.table("poll_favourite").delete().eq("poll_id", poll_id).execute()

    session.modified = True
    message = '"Poll Added to Profile!"' if favourite else '"Poll Removed From Your Profile!"'
    notification = f'{{"notification": {message}}}'
    t = render_template("results/poll-favourite.html", session=session)
    r = make_response(t)
    r.headers.set("HX-Trigger", notification)
    return r




# Helper function to query comments given a page and an count
def query_comments(poll_id, page, count):
    db = get_db()
    user_id = session["user"]["id"]
    return (
        db.table("comment")
        .select("*, like(count), dislike(count), user(*), reply:comment(count)")
        .eq("poll_id", poll_id)
        .is_("parent_id", "null")
        .order("created_at", desc=True)
        .range(page * count, (page * count) + (count - 1))
        .execute()
    )


@poll.route("/poll/comments/<poll_id>", methods=["GET", "POST"])
@requires_auth
def comments(poll_id):

    # Get all of the comments for this poll, their likes and replies
    db = get_db()
    user_id = session["user"]["id"]
    res = query_comments(poll_id, 0, COMMENT_LIMIT)

    # Call query_comment_details to get information about the comments
    del session["comments"]
    poll = session["polls"][int(poll_id)]
    session["comments"] = {c["id"]: query_comment_details(c) for c in res.data}

    # Set the full variable to True if less res is below the comment limit
    session["state"]["comment_page"] = 0
    session["state"]["comment_full"] = len(res.data) < COMMENT_LIMIT

    # Update the session 
    del session["replies"]
    session["replies"] = {}

    # Render the template
    session.modified = True
    return render_template("results/poll-comments.html", session=session, poll=poll)


@poll.route("/poll/create_comment/<poll_id>", methods=["GET", "POST"])
@requires_auth
def create_comment(poll_id):

    # If the comment is empty, send an error
    db = get_db()
    comment = request.form.get("comment")
    if not comment:
        notification = '{"notification": "Comment cannot be empty!"}'
        r = make_response("")
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", "none")
        return r

    # Insert the new comment into the database
    res = db.table("comment").insert({
        "poll_id": poll_id,
        "user_id": session["user"]["id"],
        "comment": comment
    }).execute()

    # Set additional information on the new comment 
    comment = res.data[0]
    comment["user"] = session["user"]
    comment["age"] = format_timestamp(comment["created_at"])
    comment["like_count"] = 0
    comment["dislike_count"] = 0 
    comment["reply_count"] = 0

    # Update the client-side poll object and render the comments again
    poll = session["polls"][int(poll_id)]
    poll["comment_count"] += 1 
    session["comments"][int(comment["id"])] = comment
    session.modified = True

    # Render the response template
    return render_template(
        "results/responses/comment-response.html",
        poll = poll,
        comment = comment
    )


@poll.route("/poll/load_comments/<poll_id>/<page>")
@requires_auth
def load_comments(poll_id, page):

    # Get all of the comments for this poll, their likes and replies
    db = get_db()
    page = int(page) + 1
    res = query_comments(poll_id, page, COMMENT_LIMIT)

    # Update the session variable
    comments = { c["id"] : query_comment_details(c) for c in res.data }
    session["comments"].update(comments)

    # If the query is not completely full, hide the response button
    session["state"]["comment_page"] = page
    session["state"]["comment_full"] = len(res.data) < COMMENT_LIMIT

    # Render the response template
    return render_template(
        "results/responses/load-comments-response.html",
        session=session,
        comments=comments,
        poll_id=poll_id,
    )


@poll.route("/poll/response/<poll_id>", methods=["GET", "POST"])
def response(poll_id):

    # Check if the form is empty, if it is, return immediately and notify the user
    if not request.form:
        r = make_response("")
        notification = '{"notification": "Response cannot be empty!"}'
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", "none")
        return r

    # If the user is not logged in, add their response to the session variable
    if not session.get("user"):

        # Create a list in the session variable if it doesn't already exist
        if session.get("responses") is None:
            session["responses"] = []

        # If the poll isn't already in the responses, add the user's response
        if not any([r["poll"] == poll_id for r in session["responses"]]):

            response = {
                "form": request.form.to_dict(flat=False),
                "poll": poll_id
            }
            session["responses"].append(response)
            session.modified = True

        return render_template("anonymous/submit.html")

    # Get the user and the poll from the session variable
    poll = session["polls"][int(poll_id)]
    user = session["user"]

    # Get the user's response, either from a previous response or from the form
    r = make_response("")
    poll["response"] = query_response(poll, user)

    if poll["response"] and not user["is_admin"]:
        notification = '{"notification": "You\'ve already responded to this poll!"}'
        r.headers.set("HX-Trigger", notification)
    else:
        form = request.form.to_dict(flat=False)
        poll["response"] = create_response(form, poll)
        poll["response_count"] += 1

    # Get the results and add the KDE if the poll is numeric
    poll["results"] = query_results(poll)
    if poll["poll_type"] == "NUMERIC_SCALE":
        poll["kde"] = smooth_hist(poll["results"], 0.25)

    # Fill out the HTTP response and trigger a graph draw event
    graph = '{"graph": ' + json.dumps(poll) + '}'
    r.headers.set("HX-Trigger-After-Settle", graph)
    r.data = render_template("results/result-base.html", poll=poll)
    session.modified = True
    return r


# HTTP endpoint for getting the results card
@poll.route("/poll/result/<poll_id>")
@requires_auth
def result(poll_id):

    # Get the user's response and the results, if the poll has at least 1 vote
    poll = session["polls"][int(poll_id)]
    user = session["user"]

    if poll["response_count"] > 0:
        poll["response"] = query_response(poll, user)
        poll["results"] = query_results(poll)
    else: 
        poll["response"] = {}
        poll["results"] = {}

    # If the poll is a scale, add the KDE
    if poll["poll_type"] == "NUMERIC_SCALE":
        poll["kde"] = smooth_hist(poll["results"], 0.25)

    # If the poll is ranked or tier list, get the HTML template
    r = make_response("")
    if poll["poll_type"] == "RANKED_POLL":
        r.data = render_template("results/ranked-poll.html", poll=poll)
        r.headers.set("HX-Reswap", "innerHTML")
    if poll["poll_type"] == "TIER_LIST":
        r.data = render_template("results/tier-list.html", poll=poll)
        r.headers.set("HX-Reswap", "innerHTML")

    graph = '{"graph": ' + json.dumps(poll) + '}'
    r.headers.set("HX-Trigger-After-Settle", graph)
    session.modified = True
    return r


# Report a poll
@poll.route("/poll/report/<poll_id>", methods=["GET", "POST"])
@requires_auth
def report(poll_id):

    # Get a database connection
    db = get_db()
    poll = session["polls"][int(poll_id)]

    # Insert the report into the database
    db.table("poll_report").insert({ 
        "poll_id": poll_id,
        "receiver_id": poll["creator_id"],
        "creator_id": session["user"]["id"]
    }).execute()

    # Send the user a notification
    r = make_response("")
    notification = '{"notification": "Poll Reported!"}'
    r.headers.set("HX-Trigger", notification)
    return r
