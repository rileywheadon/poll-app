from flask import render_template, redirect, url_for, request
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

    # Render the template
    return render_template("home.html", user=user, polls=polls)


# HTTP endpoint for responding to polls
@app.route("/home/respond", methods = ["GET", "POST"])
def respond():

    # Get the user ID and answer ID from the request
    user_id = request.args.get('user_id')
    answer_id = request.args.get('answer_id')

    # Get the poll ID byq uerying the database 
    answer = PollAnswer.query.get(answer_id)
    poll_id = Poll.query.get(answer.poll_id).id

    # Create a new Response and add it to the database
    response = Response(user_id = user_id, poll_id = poll_id, answer_id = answer_id)
    db.session.add(response)
    db.session.commit()
    return redirect(url_for("home"))

# Admin endpoint for viewing the responses
@app.route("/admin")
def admin():

    # Get the responses from the database
    responses = db.session.execute(db.select(Response)).scalars().all()
    print(responses)

    # Render the admin dashboard
    return render_template("admin.html", responses=responses)

# Routes for creating/deleting/updating polls (ADMIN ONLY)
@app.route("/admin/createpoll", methods = ["GET", "POST"])
def create_poll():
    return redirect(url_for("home"))

@app.route("/admin/deletepoll", methods = ["GET", "POST"])
def delete_poll():
    return redirect(url_for("home"))

@app.route("/admin/createanswer", methods = ["GET", "POST"])
def create_answer():
    return redirect(url_for("home"))

@app.route("/admin/deleteanswer", methods = ["GET", "POST"])
def delete_answer():
    return redirect(url_for("home"))
