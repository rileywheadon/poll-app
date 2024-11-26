from flask import Flask
from flask_migrate import Migrate

def create_app(test = False):

    # Create a new Flask application
    app = Flask(__name__)
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

    return app
