import os

from datetime import datetime
from functools import wraps
from flask import Blueprint, url_for, session, redirect
from flask import make_response, render_template, request
from .db import get_db
from gotrue.errors import AuthApiError
from dotenv import dotenv_values


# Create a blueprint for the authentication endpoints
auth = Blueprint('auth', __name__, template_folder='templates')


# Helper function to validate the login
def validate_auth():
    try:
        db = get_db()
        true_user = db.auth.get_user()
        session_user =  session.get("user")
        return true_user, session_user
    except:
        return None, None


# Landing page for advertising to potential users
@auth.route("/")
def landing():

    # If the user is already logged in, go to the feed
    true_user, session_user = validate_auth()
    if true_user and session_user:
        return redirect(url_for("home.feed"))

    r = make_response(render_template("landing/landing.html"))
    notification = request.args.get("notification")
    if notification:
        r.headers.set("HX-Trigger", '{"notification": ' + notification + '}')
        r.headers.set("HX-Reswap", "none")

    return r


# Login page endpoint
@auth.route('/login')
def login_page():

    # If the user is already logged in, go to the feed
    true_user, session_user = validate_auth()
    if true_user and session_user:
        return redirect(url_for("home.feed"))

    r = make_response(render_template("landing/login.html"))
    notification = request.args.get("notification")
    if notification:
        r.headers.set("HX-Trigger", '{"notification": ' + notification + '}')
        r.headers.set("HX-Reswap", "none")

    return r


# Callback after email verification
@auth.route('/auth/confirm')
def callback():

    # If the user is already logged in, go to the feed
    true_user, session_user = validate_auth()
    if true_user and session_user:
        return redirect(url_for("home.feed"))

    # Verify the magic link request
    db = get_db()
    res = db.auth.verify_otp({
        "token_hash": request.args.get("token_hash"),
        "type": "email"
    })

    # Set the session
    access_token = res.session.access_token
    refresh_token = res.session.refresh_token
    res = db.auth.set_session(access_token, refresh_token)

    # Check if the user is in the database
    user = res.user.user_metadata
    
    res = db.table("user").select("*").eq("email", user["email"]).execute()

    # If the user does not exist, add them to the database
    if not res.data:
        res = db.table("user").insert({
            "username": user["username"],
            "email": user["email"],
            "is_admin": False
        }).execute()

    # Add the user to the flask session
    session["user"] = res.data[0]

    # Get a list of the user's likes and dislikes by comment ID
    res = (
        db.table("user")
        .select("like(comment_id)", "dislike(comment_id)")
        .eq("id", session["user"]["id"])
        .execute()
    )
    session["user"]["likes"] = [c["comment_id"] for c in res.data[0]["like"]]
    session["user"]["dislikes"] = [c["comment_id"] for c in res.data[0]["dislike"]]

    # Get a list of boards
    res = db.table("board").select("*").execute()
    session["boards"] = {b["id"] : b for b in res.data}
    session["state"] = {}

    # Render the home.feed template
    session.modified = True
    session.permanent = True
    return redirect(url_for('home.feed'))


# Login endpoint
@auth.route("/auth/login", methods=["GET", "POST"])
def login():

    db = get_db()
    email = request.form.get("email")

    # Create the sign in request
    login_data = {
        "type": "email",
        "email": email,
        "options": {
            "should_create_user": False,
            "email_redirect_to": f"{request.url_root}auth/confirm",
        }
    }

    # Catch invalid email address errors
    try:
        res = db.auth.sign_in_with_otp(login_data)
    except AuthApiError as e:
        print(e)
        message = '"Invalid email!"'
        return redirect(url_for('auth.login_page', notification = message))

    message = '"Account found! Check your email to log in."'
    return redirect(url_for('auth.login_page', notification = message))


# Signup endpoint
@auth.route("/auth/register", methods=["GET", "POST"])
def register():

    db = get_db()
    email = request.form.get("email")
    username = request.form.get("username")

    # If the username is empty, throw an error
    if not username:
        message = '"Username cannot be empty!"'
        return redirect(url_for('auth.landing', notification = message))

    # If the email is already in the users table, throw an error
    res = db.table("user").select("*").eq("email", email).execute()
    if res.data:
        message = '"Email taken!"'
        return redirect(url_for('auth.landing', notification = message))
        
    # If the username is already in the users table, throw an error
    res = db.table("user").select("*").eq("username", username).execute()
    if res.data:
        message = '"Username taken!"'
        return redirect(url_for('auth.landing', notification = message))

    # Create dictionary of data for the registration
    register_data = {
        "type": "email",
        "email": email,
        "options": {
            "should_create_user": True,
            "email_redirect_to": f"{request.url_root}auth/confirm",
            "data": {"username": username}
        }
    }

    # Catch invalid email address errors
    try:
        res = db.auth.sign_in_with_otp(register_data)
    except AuthApiError as e:
        print(e)
        message = '"Invalid email!"'
        return redirect(url_for('auth.landing', notification = message))

    message = '"Success! Check your email to register!"'
    return redirect(url_for('auth.landing', notification = message))



# Log out the user and clear the endpoint
@auth.route("/auth/logout", methods=["GET", "POST"])
def logout():
    db = get_db()
    session.pop("user")
    res = db.auth.sign_out()
    return redirect(url_for("auth.landing"))


# Decorator for checking if a user is logged in
def requires_auth(f):

    @wraps(f)
    def decorated(*args, **kwargs):

        # If the user doesn't exist, clear the session and return to the index
        true_user, session_user = validate_auth()
        if not (true_user and session_user):
            return redirect(url_for("auth.landing"))

        # If the user does exist but doesn't match the session's user, log them out
        if true_user.user.user_metadata["email"] != session_user["email"]:
            return redirect(url_for("auth.logout"))

        return f(*args, **kwargs)

    return decorated


# Decorator for checking if a user is administrator
def requires_admin(f):

    @wraps(f)
    def decorated(*args, **kwargs):

        # If the user doesn't exist, clear the session and return to the index
        true_user, session_user = validate_auth()
        if not (true_user and session_user):
            return redirect(url_for("auth.landing"))

        # If the user does exist but doesn't match the session's user, log them out
        if true_user.user.user_metadata["email"] != session_user["email"]:
            return redirect(url_for("auth.logout"))

        # If the user is not an administrator, redirect them to the feed
        emails = os.environ.get("ADMIN_EMAILS").split(" ")
        if true_user.user.user_metadata["email"] not in emails:
            return redirect(url_for("home.feed"))

        return f(*args, **kwargs)

    return decorated
