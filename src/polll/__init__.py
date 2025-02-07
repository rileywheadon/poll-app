import json
import os
from urllib.parse import quote_plus, urlencode
from dotenv import find_dotenv, load_dotenv
from os import environ as env
import redis 

from flask import Flask, redirect, render_template, session, url_for, g
from flask_session import Session
from supabase import create_client, Client

def create_app(test_config=None):

    # Load the .env file, if it exists
    ENV_FILE = find_dotenv()
    if ENV_FILE:
        load_dotenv(ENV_FILE)

    # Create a new Flask application
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SESSION_TYPE = 'redis',
        SESSION_COOKIE_SAMESITE = 'None',
        SESSION_COOKIE_SECURE = True,
        SESSION_REDIS = redis.from_url(os.environ.get("REDIS_URL"))
    )

    # Add the server-side session
    Session(app)

    # Load the instance config, if it exists, when not testing
    if test_config is None:
        app.config.from_pyfile("config.py", silent=True)

    # Load the test config if passed in
    else:
        app.config.update(test_config)

    # Ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    from .utils import smooth_hist, format_time
    app.jinja_env.globals.update(smooth_hist=smooth_hist)
    app.jinja_env.globals.update(format_time=format_time)
    app.jinja_env.filters['zip'] = zip

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
