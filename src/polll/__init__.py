import json
import os
from urllib.parse import quote_plus, urlencode
from os import environ as env
from flask import Flask, redirect, render_template, session, url_for, g
from redis import Redis
from flask_session import Session
from supabase import create_client, Client

import polll.utils


def create_app(test_config=None):

    # Create a new Flask application
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY=env.get("APP_SECRET_KEY"),
        SESSION_TYPE = 'redis',
        SESSION_COOKIE_SAMESITE = 'None',
        SESSION_COOKIE_SECURE = True,
        SESSION_REDIS = Redis(host='localhost', port=6379)
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

    app.jinja_env.globals.update(smooth_hist=utils.smooth_hist)
    app.jinja_env.globals.update(format_time=utils.format_time)
    app.jinja_env.filters['zip'] = zip

    # Import the blueprints
    from polll.auth import auth
    from polll.home import home
    from polll.admin import admin
    from polll.poll import poll
    from polll.comment import comment

    # Register the blueprints
    app.register_blueprint(auth)
    app.register_blueprint(home)
    app.register_blueprint(admin)
    app.register_blueprint(poll)
    app.register_blueprint(comment)
    return app
