import json
import os
from urllib.parse import quote_plus, urlencode
from os import environ as env
from flask import Flask, redirect, render_template, session, url_for


def create_app(test_config=None):
    # Create a new Flask application
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY=env.get("APP_SECRET_KEY"),
        DATABASE=os.path.join(app.instance_path, "polll.sqlite")
    )

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

    # Register the database commands
    from . import db
    db.init_app(app)

    # Register the application with Auth0
    from polll.auth import oauth
    domain = env.get("AUTH0_DOMAIN")
    oauth.init_app(app)
    oauth.register(
        "auth0",
        client_id=env.get("AUTH0_CLIENT_ID"),
        client_secret=env.get("AUTH0_CLIENT_SECRET"),
        client_kwargs={"scope": "openid profile email"},
        server_metadata_url=f'https://{domain}/.well-known/openid-configuration'
    )

    # Register the authentication, poll, and admin blueprints
    from polll.auth import auth
    from polll.poll import poll
    from polll.admin import admin
    app.register_blueprint(auth)
    app.register_blueprint(poll)
    app.register_blueprint(admin)
    return app
