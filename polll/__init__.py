import json
import os
import redis
from dotenv import find_dotenv, load_dotenv
from urllib.parse import quote_plus, urlencode

from flask import Flask, redirect, render_template, session, url_for, g
from flask_session import Session
from supabase import create_client, Client


# Error handler for 404 Not Found
def error_404(e):
    return render_template("404.html"), 404


# Error handler for 500 Internal Server Error
def error_500(e):
    return render_template("500.html"), 500


# Application factory
def create_app():

    # Create a new Flask application
    app = Flask(__name__)

    # Configure the Flask application
    app.config['DEBUG'] = os.environ.get('DEBUG', False)
    app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY")
    app.config["SESSION_TYPE"] = "redis"
    app.config["SESSION_COOKIE_SAMESITE"] = "None"
    app.config["SESSION_COOKIE_SECURE"] = True

    # Connect to the correct server-side session
    if os.environ.get("ENVIRONMENT") == "development":
        app.config["SESSION_REDIS"] = redis.Redis(host='localhost', port=6379)
    else:
        redis_url = f"{os.environ.get('REDIS_URL')}?ssl_cert_reqs=none"
        app.config["SESSION_REDIS"] = redis.from_url(redis_url)

    # Add the server-side session
    Session(app)

    # Import some formatting functions for use in Jinja templates 
    from .utils import smooth_hist, format_time
    app.jinja_env.globals.update(smooth_hist=smooth_hist)
    app.jinja_env.globals.update(format_time=format_time)

    # Register error handlers
    app.register_error_handler(404, error_404)
    app.register_error_handler(500, error_500)

    # Import the blueprints
    from .auth import auth
    from .home import home
    from .admin import admin
    from .poll import poll
    from .comment import comment

    # Register the blueprints
    app.register_blueprint(auth)
    app.register_blueprint(home)
    app.register_blueprint(admin)
    app.register_blueprint(poll)
    app.register_blueprint(comment)
    return app
