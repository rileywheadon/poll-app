from os import environ as env
from datetime import datetime
from functools import wraps
from authlib.integrations.flask_client import OAuth
from flask import Blueprint, url_for, session, redirect
from urllib.parse import quote_plus, urlencode

from polll.db import get_db

# Lazily create and export the authenticator
oauth = OAuth()

# Create a blueprint for the authentication endpoints
auth = Blueprint('auth', __name__, template_folder='templates')


# Login endpoint
@auth.route('/login')
def login():

    # If user is logged in, redirect to home
    if "user" in session and session["user"]["id"] != None:
        return redirect(url_for("home.feed"))

    # Otherwise hit the auth0 authentication endpoint
    uri = url_for("auth.callback", _external=True)
    return oauth.auth0.authorize_redirect(redirect_uri=uri)


# Signup endpoint
@auth.route("/register")
def register():

    # If user is logged in, redirect to home
    if "user" in session and session["user"]["id"] != None:
        return redirect(url_for("home.feed"))

    # Otherwise hit the auth0 authentication endpoint
    uri = url_for("auth.callback", _external=True)
    return oauth.auth0.authorize_redirect(redirect_uri=uri, screen_hint="signup")


# Callback endpoint
@auth.route("/callback", methods=["GET", "POST"])
def callback():

    token = oauth.auth0.authorize_access_token()
    email = token["userinfo"]["email"]
    username = token["userinfo"]["nickname"]
    db = get_db()
    cur = db.cursor()

    # Check if the user is in the database
    res = cur.execute(f"SELECT * FROM user WHERE email=?", (email,))

    # If the user doesn't exist add them to the database
    if res.fetchone() is None:
        query = """
        INSERT INTO user (username, email, account_created, last_online)
            VALUES (?, ?, ?, ?)
        """
        now = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        values = (username, email, now, now)
        cur.execute(query, values)
        db.commit()

    # Then set session["user"] to the current user (as a dictionary)
    query = """
    SELECT *
    FROM user
    WHERE email=?
    """
    res = cur.execute(query, (email,))
    session["user"] = dict(res.fetchone())

    # Iterate through the list of responses and add them to the database
    if session.get("responses"):
        from polll.models import validate_response
        for response in session["responses"]:
            validate_response(response["form"], response["poll"])

    # Reset the responses dictionary and redirect the user to their feed
    session["responses"] = []
    session.modified = True
    return redirect(url_for("home.feed"))


# Logout endpoint
@auth.route("/logout")
def logout():

    # Remove the user data from the session
    session.clear()

    # Hit the Auth0 return_url to finalize this change
    return_data = {
        "returnTo": url_for("home.index", _external=True),
        "client_id": env.get('AUTH0_CLIENT_ID')
    }

    return_query = urlencode(return_data, quote_via=quote_plus)
    return redirect(f"https://{env.get('AUTH0_DOMAIN')}/v2/logout?{return_query}")


# Decorator for checking if a user is logged in
def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if not session["user"]["id"]:
            return redirect(url_for('auth.login'))

        return f(*args, **kwargs)

    return decorated


# Decorator for checking if a user is administrator
def requires_admin(f):
    @wraps(f)
    def decorated(*args, **kwargs):

        if not session["user"]["id"]:
            return redirect(url_for('auth.login'))

        elif session["user"]["email"] != "admin@polll.org":
            return redirect(url_for('home.feed'))

        return f(*args, **kwargs)

    return decorated
