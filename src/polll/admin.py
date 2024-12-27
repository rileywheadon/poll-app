from flask import Blueprint, render_template, redirect, url_for, request, session
from datetime import datetime

from polll.auth import requires_auth, requires_admin
from polll.db import get_db
from polll.models import on_cooldown 

admin = Blueprint('admin', __name__, template_folder = 'templates/admin')

# Admin endpoint for getting to the editor and responses
@admin.route("/admin")
@requires_admin
def home():
    return render_template("admin.html", user=session["user"], admin=True)


@admin.route("/admin/users")
@requires_admin
def users():
    return render_template("users.html", tab="users") 

@admin.route("/admin/users/search")
@requires_admin
def search():

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the headers from the HTTP request
    col = request.args.get("search_column")
    val = "%{}%".format(request.args.get("search_value"))

    # Query the database for all users matching the search
    res = cur.execute("SELECT * FROM user WHERE ? LIKE ?", (col, val))
    users = [dict(row) for row in res.fetchall()]

    # Update the cooldown state for each user
    for user in users:
        user["on_cooldown"] = on_cooldown(user)

    return render_template("users-list.html", users=users)


@admin.route("/admin/users/resetcooldown")
@requires_admin
def resetcooldown():

    # Get a database connection
    db = get_db()
    cur = db.cursor()

    # Get the user ID from the HTTP request
    user_id = request.args.get("user_id")

    # Update the user's next_poll_allowed value
    query = """
    UPDATE user 
    SET next_poll_allowed = ?
    WHERE id = ?
    """
    now = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    res = cur.execute(query, (now, user_id))
    db.commit()

    # UI Changes are handled in Javascript
    return ""



@admin.route("/admin/polls")
@requires_admin
def polls():
    return render_template("polls.html", tab="polls") 


@admin.route("/admin/reports")
@requires_admin
def reports():
    return render_template("reports.html", tab="reports") 
