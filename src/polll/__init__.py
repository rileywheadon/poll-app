import json
import os
from urllib.parse import quote_plus, urlencode

from redis import Redis, from_url
from flask import Flask, redirect, render_template, session, url_for, g
from flask_session import Session
from supabase import create_client, Client


# Error handler for 404 Not Found
def error_404(e):
    return render_template("404.html"), 404


# Error handler for 500 Internal Server Error
def error_500(e):
    return render_template("500.html"), 500


# Initialize the session
sess = Session()


# Application factory
def create_app():

    # Create a new Flask application
    app = Flask(__name__)

    # Development configuration
    if os.environ.get("DEVELOPMENT"):
        app.config.from_mapping(
            SECRET_KEY = os.environ.get("SECRET_KEY"),
            SESSION_TYPE = 'redis',
            SESSION_COOKIE_SAMESITE = 'None',
            SESSION_COOKIE_SECURE = True,
            SESSION_PERMANENT = True,
            SESSION_REDIS = Redis(host='localhost', port=6379)
        )

    # Production configuration
    else:
        redis_url = f"{os.environ.get("REDIS_URL")}?ssl_cert_reqs=none"
        app.config.from_mapping(
            SECRET_KEY = os.environ.get("SECRET_KEY"),
            SESSION_TYPE = 'redis',
            SESSION_COOKIE_SAMESITE = 'None',
            SESSION_COOKIE_SECURE = True,
            SESSION_PERMANENT = True,
            SESSION_REDIS = from_url(redis_url)
        )

    # Add the server-side session
    sess.init_app(app)

    # Register error handlers
    app.register_error_handler(404, error_404)
    app.register_error_handler(500, error_500)

    # Import some formatting functions for use in Jinja templates 
    app.jinja_env.globals.update(smooth_hist=utils.smooth_hist)
    app.jinja_env.globals.update(format_time=utils.format_time)
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
