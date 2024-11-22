from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import sqlalchemy as sa
import sqlalchemy.orm as so

# Create a new app instance
app = Flask(__name__)

# Base class for declarative class definitions
class Base(so.DeclarativeBase):

    # Define a custom constraint naming convention
    metadata = sa.MetaData(naming_convention={
        "ix": 'ix_%(column_0_label)s',
        "uq": "uq_%(table_name)s_%(column_0_name)s",
        "ck": "ck_%(table_name)s_%(constraint_name)s",
        "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
        "pk": "pk_%(table_name)s"
    })

# Initialize a database using DeclarativeBase
db = SQLAlchemy(model_class=Base)

# Set the database URI to /instance/app.db
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///app.db"

# Link the app to the database
db.init_app(app)

# Enable database migrations
migrate = Migrate(app, db)

# Import data models from models.py 
from models import *

# Create database tables
with app.app_context():
    db.create_all()

# Define HTTP endpoints in routes.py
from routes import *
