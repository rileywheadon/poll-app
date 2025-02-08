from flask import Blueprint, render_template, redirect, url_for
from flask import request, session, make_response
from datetime import datetime, timedelta
import requests

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.utils import *

admin = Blueprint('admin', __name__, template_folder='templates/admin')


@admin.route("/admin/users")
@requires_admin
def users():

    # Get the headers from the HTTP request, if they exist
    db = get_db()
    column = request.args.get("column") or "username"
    search = request.args.get("search") or ""

    # Include similar values in the query, unless we are searching by ID
    res = None
    if column == "id":
        res = db.table("user").select("*").eq("id", search).execute()
    else:
        res = db.table("user").select("*").like(column, "%{}%".format(search)).execute()

    users = res.data

    # Update the cooldown state for each user
    for user in users:
        user["on_cooldown"] = on_cooldown(user)

    # If the request is internal, only re-render the user list
    target = request.headers.get("HX-Target")
    if target and target == "users-list":
        return render_template("users-list.html", users=users)

    # Update the session object
    session["users"] = {u["id"]: u for u in users}
    session["state"] = {"admin": True, "tab": "users"}
    form = {"column": column, "search": search}
    return render_template("users.html", session=session, users=users, form=form)


# Resets the user's poll cooldown
@admin.route("/admin/users/refresh")
@requires_admin
def refresh():

    # Get the user ID from the HTTP request
    db = get_db()
    user_id = request.args.get("user_id")

    # Update the user's next_poll_allowed value
    now = datetime.now().astimezone().isoformat()
    res = (
        db.table("user")
        .update({"next_poll_allowed": now})
        .eq("id", user_id)
        .execute()
    )

    # Fetch the user so they can be rendered by the client
    user = session["users"][int(user_id)]
    user["next_poll_allowed"] = now
    user["on_cooldown"] = False

    # UI Changes are handled in Javascript
    session.modified = True
    return render_template("admin/users-table.html", user=user)


# Mute user (DISABLED)
# @admin.route("/admin/users/mute")
# @requires_admin
# def mute():
#
#     # Get request information and current user state
#     db = get_db()
#     user_id = request.args.get("user_id")
#     user = session["users"][int(user_id)]
#     is_muted = user["is_muted"]
#     
#     # Update the user's state in both the database and the session object
#     db.table("user").update({"is_muted": not is_muted}).eq("id", user_id).execute()
#     user["is_muted"] = not is_muted
#
#     # Swap out the button
#     session.modified = True
#     return render_template("admin/users-mute.html", user=user)


# Ban user (DISABLED)
# @admin.route("/admin/users/ban")
# @requires_admin
# def ban():
#
#     db = get_db()
#     user_id = request.args.get("user_id")
#     user = session["users"][int(user_id)]
#     is_banned = user["is_banned"]
#     
#     # Update the user's state in both the database and the session object
#     db.table("user").update({"is_banned": not is_banned}).eq("id", user_id).execute()
#     user["is_banned"] = not is_banned
#     
#     # Swap out the button
#     session.modified = True
#     return render_template("admin/users-ban.html", user=user)


# Get all reported comments
@admin.route("/admin/comments")
@requires_admin
def comments():

    # Get a database connection and get all the comment reports
    db = get_db()
    res = (
        db.table("comment_report")
        .select(
            "*", 
            "comment(comment)", 
            "creator:creator_id(id, username)", 
            "receiver:receiver_id(id, username)"
        )
        .order("handled")
        .order("created_at")
        .execute()
    )
    reports = res.data

    # Rearrange the dictionary to make it easier to read
    for r in reports:
        r["content"] = r["comment"]["comment"]
        del r["comment"]

    # Set the state variable 
    session["state"] = {"admin": True, "tab": "comments"}
    session["comment_reports"] = {r["id"] : r for r in reports}

    # Render the response
    session.modified = True
    return render_template("comments.html", session=session, reports=reports)


# Mark a comment report as handled
@admin.route("/admin/comments/handle/<report_id>")
@requires_admin
def handle_comment(report_id):
    
    # Swap the comment's state in the session
    report = session["comment_reports"][int(report_id)]
    report["handled"] = not report["handled"]

    # Swap the comment's state in the database
    db = get_db()
    res = (
        db.table("comment_report")
        .update({"handled": report["handled"]})
        .eq("id", report_id)
        .execute()
    )
                                                                             
    # Render the comment's header again
    session.modified = True
    return render_template("admin/comments-alert.html", report=report)


@admin.route("/admin/polls")
@requires_admin
def polls():

    # Get a database connection and get all the poll reports
    db = get_db()
    res = (
        db.table("poll_report")
        .select(
            "*", 
            "poll(question, answer(answer))", 
            "creator:creator_id(id, username)", 
            "receiver:receiver_id(id, username)"
        )
        .order("handled")
        .order("created_at")
        .execute()
    )
    reports = res.data

    # Rearrange the dictionary to make it easier to read
    for r in reports:
        r["question"] = r["poll"]["question"]
        r["answers"] = [a["answer"] for a in r["poll"]["answer"]]
        del r["poll"]

    # Set the state variable 
    session["state"] = {"admin": True, "tab": "polls"}
    session["poll_reports"] = {r["id"] : r for r in reports}

    # Render the response
    session.modified = True
    return render_template("polls.html", session=session, reports=reports)


# Mark a comment report as handled
@admin.route("/admin/polls/handle/<report_id>")
@requires_admin
def handle_poll(report_id):
    
    # Swap the comment's state in the session
    report = session["poll_reports"][int(report_id)]
    report["handled"] = not report["handled"]

    # Swap the comment's state in the database
    db = get_db()
    res = (
        db.table("poll_report")
        .update({"handled": report["handled"]})
        .eq("id", report_id)
        .execute()
    )
                                                                             
    # Render the comment's header again
    session.modified = True
    return render_template("admin/polls-alert.html", report=report)


@admin.route("/admin/boards")
@requires_admin
def boards():

    # Select all boards from the database
    db = get_db()
    res = db.table("board").select("*").execute()
    session["boards"] = {b["id"] : b for b in res.data}

    # Render the template
    session["state"] = {"admin": True, "tab": "boards"}
    session.modified = True
    return render_template("boards.html", session=session)


@admin.route("/admin/boards/create")
@requires_admin
def create_board():

    # Check that the board name is unique
    db = get_db()
    name = request.args.get("name")
    names = [b["name"] for id, b in session["boards"].items()]

    # If the name is not unique, do nothing and notify the user
    if name in names:
        r = make_response("")
        notification = '{"notification": "Board already exists!"}'
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", "none")
        return r

    # Add the board to the database
    res = db.table("board").insert({"name": name}).execute()

    # Add the board to the list of boards stored in the session
    board = res.data[0]
    session["boards"][board["id"]] = board
    session.modified = True

    # Render the boards list again
    r = make_response(render_template("boards-list.html", session=session))
    notification = '{"notification": "Board created!"}'
    r.headers.set("HX-Trigger", notification)
    return r


@admin.route("/admin/boards/delete/<board_id>")
@requires_admin
def delete_board(board_id):

    # Remove the board (cascade should take care of poll_board)
    db = get_db()
    db.table("board").delete().eq("id", board_id).execute()

    # Delete the board from the session
    del session["boards"][int(board_id)]

    # Render the boards list again
    r = make_response(render_template("boards-list.html", session=session))
    notification = '{"notification": "Board deleted!"}'
    r.headers.set("HX-Trigger", notification)
    return r


# Swaps a board from primary to non-primary and vice-versa
@admin.route("/admin/boards/update/<board_id>")
@requires_admin
def update_board(board_id):

    # Update the board in the session
    board = session["boards"][int(board_id)]
    board["primary"] = not board["primary"]

    # Update the board in the database
    db = get_db()
    db.table("board").update({"primary": board["primary"]}).eq("id", board_id).execute()
    return ""

