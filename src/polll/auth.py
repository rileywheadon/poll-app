from os import environ as env
from datetime import datetime
from functools import wraps
from flask import Blueprint, url_for, session, redirect, render_template, request
from polll.db import get_db
from gotrue.errors import AuthApiError


# Create a blueprint for the authentication endpoints
auth = Blueprint('auth', __name__, template_folder='templates')


# Landing page for advertising to potential users
@auth.route("/")
def index():
    return render_template("index.html")


# Authentication page endpoint
@auth.route('/<action>')
def authenticate(action):

    # If the user is already logged in, go to the feed
    if session.get("user"):
        return redirect(url_for("home.feed"))

    error = request.args.get("error")
    return render_template("auth/authentication.html", action=action, error=error)


# Callback after email verification
@auth.route('/auth/confirm')
def callback():

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
            "is_muted": False,
            "is_banned": False,
            "is_admin": True
        }).execute()

    # Add the user to the flask session
    session["user"] = res.data[0]

    # Render the home.feed template
    return redirect(url_for('home.feed'))


# Helper function to throw a redirect with a given error
def invalid_login(action, error):
    return redirect(url_for("auth.authenticate", action=action, error=error))


# Login endpoint
@auth.route("/auth/login", methods=["GET", "POST"])
def login():

    db = get_db()

    # Create the sign in request
    login_data = {
        "type": "email",
        "email": request.form.get("email"),
        "options": {
            "should_create_user": False,
            "email_redirect_to": f"{request.url_root}confirm",
        }
    }

    # Catch invalid email address errors
    try:
        res = db.auth.sign_in_with_otp(login_data)
    except AuthApiError as e:
        return invalid_login("login", "email")

    return render_template("auth/verify-email.html")


# Signup endpoint
@auth.route("/auth/register", methods=["GET", "POST"])
def register():

    db = get_db()
    email = request.form.get("email")
    username = request.form.get("username")

    # If the username is empty, throw an error
    if not username:
        return invalid_login("register", "name")

    # If the email is already in the users table, throw an error
    res = db.table("user").select("*").eq("email", email).execute()
    if res.data:
        return invalid_login("register", "duplicate_email")

    # If the username is already in the users table, throw an error
    res = db.table("user").select("*").eq("username", username).execute()
    if res.data:
        return invalid_login("register", "duplicate_name")

    # Create dictionary of data for the registration
    register_data = {
        "type": "email",
        "email": email,
        "options": {
            "should_create_user": True,
            "email_redirect_to": f"{request.url_root}confirm",
            "data": {"username": request.form.get("username")}
        }
    }

    # Catch invalid email address errors
    try:
        res = db.auth.sign_in_with_otp(register_data)
    except AuthApiError as e:
        return redirect(url_for("auth.authenticate", action="register", error="email"))

    return render_template("auth/verify-email.html")


# Log out the user and clear the endpoint
@auth.route("/auth/logout", methods=["GET", "POST"])
def logout():
    db = get_db()
    res = db.auth.sign_out()
    session.pop("user")
    return redirect(url_for("auth.index"))


# Decorator for checking if a user is logged in
def requires_auth(f):

    @wraps(f)
    def decorated(*args, **kwargs):

        if not session.get("user"):
            return redirect(url_for("auth.index"))

        return f(*args, **kwargs)

    return decorated


# Decorator for checking if a user is administrator
def requires_admin(f):
    @wraps(f)
    def decorated(*args, **kwargs):

        if not session.get("user"):
            return redirect(url_for("auth.index"))

        elif not session["user"]["is_admin"]:
            return redirect(url_for("home.feed"))

        return f(*args, **kwargs)

    return decorated
