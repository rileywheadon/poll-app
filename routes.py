from flask import render_template
from app import app, db
from models import *

# Landing page for advertising to potential users
@app.route("/")
def index():
    return render_template("index.html")

# Login window for authenticating users
# @app.route("/login")

# Main app page for answering polls
@app.route("/home")
def home():

    # Check if the user is logged in, if not, redirect to landing
    # ...

    # Query the database to get the first user
    user = db.session.execute(db.select(User)).scalar()

    # Query the database to get all polls
    polls = db.session.execute(db.select(Poll)).scalars().all()

    # Renderthe template
    return render_template("home.html", user=user, polls=polls)

