import json
import os
from urllib.parse import quote_plus, urlencode
from os import environ as env

from flask import Flask, redirect, render_template, session, url_for, g
from redis import Redis
from flask_session import Session
from supabase import create_client, Client

import polll.utils as utils

# Error handler for 404 Not Found
def error_404(e):
    return render_template("404.html"), 404


# Error handler for 500 Internal Server Error
def error_500(e):
    return render_template("500.html"), 500


# Application factory
def create_app():

    # Create a new Flask application
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SESSION_TYPE = 'redis',
        SESSION_COOKIE_SAMESITE = 'None',
        SESSION_COOKIE_SECURE = True,
        SESSION_REDIS = Redis(host='localhost', port=6379)
    )

    # Add the server-side session
    Session(app)

    # Register error handlers
    app.register_error_handler(404, error_404)
    app.register_error_handler(500, error_500)

    # Import some formatting functions for use in Jinja templates 
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
