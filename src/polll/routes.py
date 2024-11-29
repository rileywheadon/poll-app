from flask import render_template, redirect, url_for, request, current_app, session
from flask_login import current_user
from polll.models import *
from polll.decorators import requires_auth


# Landing page for advertising to potential users
@current_app.route("/")
def index():
    return render_template("index.html")


# Main app page for answering polls
@current_app.route("/home")
@requires_auth
def home():

   # Query the database to get all polls
    polls = db.session.execute(db.select(Poll)).scalars().all()

    # Render the template
    return render_template("home.html", user = current_user, polls = polls)


# HTTP endpoint for responding to polls
@current_app.route("/home/respond", methods = ["GET", "POST"])
@requires_auth
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
        response = Response(
            user_id = user_id, 
            poll_id = poll_id, 
            answer_id = answer_id
        )

        db.session.add(response)
        db.session.commit()

    return redirect(url_for("home"))


# Admin endpoint for getting to the editor and responses
@current_app.route("/admin")
@requires_auth
def admin():
    polls = db.session.execute(db.select(Poll)).scalars().all()
    responses = db.session.execute(db.select(Response)).scalars().all()
    return render_template("admin.html", polls = polls, responses = responses)


@current_app.route("/admin/createpoll")
@requires_auth
def create_poll():
    poll = Poll(
        user = current_user,
        question = '', 
        poll_type = request.args.get("poll_type"), 
        reveals = 0,
        reports = 0,
    )

    db.session.add(poll)
    db.session.commit()
    return render_template("admin/poll-active.html", poll = poll)


@current_app.route("/admin/deletepoll/<poll_id>")
@requires_auth
def delete_poll(poll_id):
    Poll.query.filter(Poll.id == poll_id).delete()
    PollAnswer.query.filter(PollAnswer.poll_id == poll_id).delete()
    Response.query.filter(Response.poll_id == poll_id).delete()
    db.session.commit()
    return ""


@current_app.route("/admin/editpoll/<poll_id>")
@requires_auth
def edit_poll(poll_id):
    poll = Poll.query.get(poll_id)
    return render_template("admin/poll-active.html", poll = poll)


@current_app.route("/admin/savepoll/<poll_id>")
@requires_auth
def save_poll(poll_id):
    poll = Poll.query.get(poll_id)
    poll.question = request.args.get("poll_text")

    for key, value in request.args.items():
        answer_id = key.split("_")[1]

        try:
            answer = PollAnswer.query.get(int(answer_id))
            answer.answer = request.args.get(key)
        except:
            continue

    db.session.commit()
    return render_template("admin/poll-inactive.html", poll = poll)


@current_app.route("/admin/addanswer/<poll_id>")
@requires_auth
def add_answer(poll_id):
    answer_text = request.args.get("answer_text")
    answer = PollAnswer(answer = answer_text, poll_id = poll_id)
    db.session.add(answer)
    db.session.commit()
    poll = Poll.query.get(poll_id)
    return render_template("admin/poll-active-list.html", poll = poll)


@current_app.route("/admin/deleteanswer/<answer_id>")
@requires_auth
def delete_answer(answer_id):
    PollAnswer.query.filter(PollAnswer.id == answer_id).delete()
    db.session.commit()
    return ""

