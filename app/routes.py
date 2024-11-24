from flask import render_template, redirect, url_for, request
from app import app, db
from app.models import *

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

    # Only process the request if answer_id exists
    if answer_id:

        # Get the poll ID byq uerying the database 
        answer = PollAnswer.query.get(answer_id)
        poll_id = Poll.query.get(answer.poll_id).id

        # Create a new Response and add it to the database
        response = Response(user_id = user_id, poll_id = poll_id, answer_id = answer_id)
        db.session.add(response)
        db.session.commit()

    return redirect(url_for("home"))

# Admin endpoint for getting to the editor and responses
@app.route("/admin")
def admin():
    return render_template("admin.html")

# Admin endpoint for editing the polls. 
@app.route("/admin/edit")
def admin_edit():
    active = request.args.get('poll_id')
    polls = db.session.execute(db.select(Poll)).scalars().all()
    return render_template("admin-edit.html", polls=polls, active=active)

# Admin endpoint for editing a poll
@app.route("/admin/edit/editpoll", methods = ["GET", "POST"])
def edit_poll():
    poll_id = request.args.get('poll_id')
    return redirect(url_for("admin_edit", poll_id=poll_id))

# Admin endpoint for saving a poll, setting poll_id to 0
@app.route("/admin/edit/savepoll", methods = ["GET", "POST"])
def save_poll():
    poll_id = request.args.get('poll_id')
    poll = Poll.query.get(poll_id)
    poll_text = request.args.get('poll_text')

    if poll_text:
        poll.question = poll_text
        db.session.commit()

    return redirect(url_for("admin_edit", poll_id=0))


# Routes for creating/deleting/updating polls 
@app.route("/admin/edit/createpoll", methods = ["GET", "POST"])
def create_poll():
    poll = Poll(question='')
    db.session.add(poll)
    db.session.commit()
    return redirect(url_for("admin_edit", poll_id = poll.id))


# Delete all PollAnswers as well as the poll itself
@app.route("/admin/edit/deletepoll", methods = ["GET", "POST"])
def delete_poll():
    poll_id = request.args.get('poll_id')
    Poll.query.filter_by(id = poll_id).delete()
    PollAnswer.query.filter_by(poll_id = poll_id).delete()
    Response.query.filter_by(poll_id = poll_id).delete()
    db.session.commit()
    return redirect(url_for("admin_edit"))


@app.route("/admin/edit/createanswer", methods = ["GET", "POST"])
def create_answer():
    poll_id = request.args.get('poll_id')
    answer_text = request.args.get('answer_text')

    if answer_text:
        answer = PollAnswer(answer = answer_text, poll_id = poll_id)
        db.session.add(answer)
        db.session.commit()

    return redirect(url_for("admin_edit", poll_id = poll_id))

@app.route("/admin/edit/deleteanswer", methods = ["GET", "POST"])
def delete_answer():
    poll_id = request.args.get('poll_id')
    answer_id= request.args.get('answer_id')
    PollAnswer.query.filter_by(id = answer_id).delete()
    Response.query.filter_by(answer_id = answer_id).delete()
    db.session.commit()
    return redirect(url_for("admin_edit", poll_id = poll_id))


# Admin endpoint for viewing the responses
@app.route("/admin/dashboard")
def admin_dashboard():
    responses = db.session.execute(db.select(Response)).scalars().all()
    return render_template("admin-dashboard.html", responses=responses)
