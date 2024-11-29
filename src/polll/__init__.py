import json
from urllib.parse import quote_plus, urlencode
from os import environ as env
from flask import Flask, redirect, render_template, session, url_for
from flask_login import LoginManager
from flask_migrate import Migrate

def create_app(test = False):

    # Create a new Flask application
    app = Flask(__name__)
    app.secret_key = env.get("APP_SECRET_KEY")
    db_url = "test.db" if test else "app.db"
    app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_url}"

    # Link the app to the database
    from polll.models import db
    db.init_app(app)

    # Import data models and routes, then initialize the database
    with app.app_context():
        from . import routes
        db.create_all()

    # Enable database migrations
    if not test: 
        migrate = Migrate(app, db)

    # Register the application with 0Auth
    from polll.authentication import oauth
    domain = env.get("AUTH0_DOMAIN")
    oauth.init_app(app)
    oauth.register(
        "auth0",
        client_id=env.get("AUTH0_CLIENT_ID"),
        client_secret=env.get("AUTH0_CLIENT_SECRET"),
        client_kwargs={"scope": "openid profile email"},
        server_metadata_url=f'https://{domain}/.well-known/openid-configuration'
    )

    # Register the authentication blueprint and add the login manager
    from polll.authentication import auth, login_manager
    app.register_blueprint(auth)
    login_manager.init_app(app)
    return app
