from os import environ as env
import secrets

from authlib.integrations.flask_client import OAuth
from flask import Blueprint, url_for, session, redirect, flash
from urllib.parse import quote_plus, urlencode
from flask_login import LoginManager, current_user, login_user, logout_user

from polll.models import db, User

# Lazily create and export the authenticator
oauth = OAuth()

# Lazily create and export the login manager
login_manager = LoginManager()
login_manager.login_view = "index"

# Create a blueprint for the authentication endpoints
auth = Blueprint('auth', __name__, template_folder = 'templates')

# Login endpoint
@auth.route('/login')
def login():

    # If the user is already logged in, send them to the home page
    if not current_user.is_anonymous:
        return redirect(url_for('home'))

    uri = url_for("auth.callback", _external = True)
    return oauth.auth0.authorize_redirect(redirect_uri = uri)

# Signup endpoint
@auth.route("/register")
def register():

    # If the user is already logged in, send them to the home page
    if not current_user.is_anonymous:
        return redirect(url_for('home'))

    uri = url_for("auth.callback", _external = True)
    return oauth.auth0.authorize_redirect(redirect_uri = uri, screen_hint = "signup")

# Callback endpoint
@auth.route("/callback", methods=["GET", "POST"])
def callback():

    # If the user is already logged in, skip this step
    if not current_user.is_anonymous and session["user"]:
        return redirect(url_for('home'))

    # If there was an authentication error, flash the error messages and exit
    token = oauth.auth0.authorize_access_token()
    session["user"] = token

    # Add the user to the database if this is their first time logging in
    nickname = session["user"]["userinfo"]["nickname"]
    email = session["user"]["userinfo"]["email"]
    user = User.query.filter(User.email == email).scalar()

    # If the user is not new log them in and continue
    if user is not None:
        login_user(user)
        return redirect("/home")

    # Otherwise add a new user to the database
    new_user = User(username = nickname, email = email)
    db.session.add(new_user)
    db.session.commit()
    login_user(new_user)
    return redirect("/home")


# Logout endpoint
@auth.route("/logout")
def logout():

    # Remove the user data from the session and flask-login
    session.clear()
    logout_user()
    flash('You have been logged out.')

    # Hit the Auth0 return_url to finalize this change
    return_data = {
        "returnTo": url_for("index", _external=True),
        "client_id": env.get('AUTH0_CLIENT_ID')
    }

    return_query = urlencode(return_data, quote_via = quote_plus)
    return redirect(f"https://{env.get('AUTH0_DOMAIN')}/v2/logout?{return_query}")

# Create the user_loader HTTP endpoint
@login_manager.user_loader
def load_user(id):
    return db.session.get(User, int(id))

