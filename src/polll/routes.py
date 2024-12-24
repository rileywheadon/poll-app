from flask import render_template, redirect, url_for, request, current_app, session
from flask_login import current_user
from polll.models import *
import polll.responses as response
from polll.decorators import requires_auth, requires_admin

# Import result handlers
import polll.results as result


# Landing page for advertising to potential users
@current_app.route("/")
def index():
    return render_template("index.html")


# Home page (empty)
@current_app.route("/home")
@requires_auth
def home():

    # Render the template
    return render_template("home.html", user=current_user)


# Home page (poll feed)
@current_app.route("/home/feed")
@requires_auth
def feed():

   # Query the database to get all polls
    polls = db.session.execute(db.select(Poll)).scalars().all()

    # Render the template
    return render_template("home/feed.html", user=current_user, polls=polls, tab='feed')


# Home page (response history)
@current_app.route("/home/history")
@requires_auth
def history():

    # Render the template
    return render_template("home/history.html", user=current_user, tab='history')


# Home page (create poll)
@current_app.route("/home/create")
@requires_auth
def create():

    # Render the template
    return render_template("home/create.html", user=current_user, tab='create')


# Home page (user's polls)
@current_app.route("/home/mypolls")
@requires_auth
def mypolls():

    # Render the template
    return render_template("home/mypolls.html", user=current_user, tab='mypolls')


# HTTP endpoint for responding to polls
@current_app.route("/home/respond/<poll_id>", methods=["GET", "POST"])
@requires_auth
def respond(poll_id):

    poll = Poll.query.get(poll_id)
    match poll.poll_type:
        case PollType.CHOOSE_ONE:
            return response.choose_one(request, poll, current_user)
        case PollType.CHOOSE_MANY:
            return response.choose_many(request, poll, current_user)
        case PollType.NUMERIC_STAR:
            return response.numeric_star(request, poll, current_user)
        case PollType.NUMERIC_SCALE:
            return response.numeric_scale(request, poll, current_user)
        case PollType.RANKED_POLL:
            return response.ranked_poll(request, poll, current_user)
        case PollType.TIER_LIST:
            return response.tier_list(request, poll, current_user)

    # This should never happen
    return redirect(url_for("home"))


# HTTP endpoint for refreshing the results
@current_app.route("/home/results/<poll_id>", methods=["GET", "POST"])
@requires_auth
def results(poll_id):

    poll = Poll.query.get(poll_id)
    match poll.poll_type:
        case PollType.CHOOSE_ONE:
            return result.choose_one(request, poll)
        case PollType.CHOOSE_MANY:
            return result.choose_many(request, poll)
        case PollType.NUMERIC_STAR:
            return result.numeric_star(request, poll)
        case PollType.NUMERIC_SCALE:
            return result.numeric_scale(request, poll)
        case PollType.RANKED_POLL:
            return result.ranked_poll(request, poll)
        case PollType.TIER_LIST:
            return result.tier_list(request, poll)

    # This should never happen
    return redirect(url_for("home"))


# Admin endpoint for getting to the editor and responses
@current_app.route("/admin")
@requires_admin
def admin():
    polls = db.session.execute(db.select(Poll)).scalars().all()
    responses = db.session.execute(db.select(Response)).scalars().all()
    return render_template("admin.html", polls=polls, responses=responses)


@current_app.route("/admin/createpoll")
@requires_auth
def create_poll():
    poll = Poll(
        user=current_user,
        question='',
        poll_type=request.args.get("poll_type"),
        reveals=0,
        reports=0,
    )

    db.session.add(poll)
    db.session.commit()
    return render_template("admin/poll-active.html", poll=poll)


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
    return render_template("admin/poll-active.html", poll=poll)


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
    return render_template("admin/poll-inactive.html", poll=poll)


@current_app.route("/admin/addanswer/<poll_id>")
@requires_auth
def add_answer(poll_id):
    answer_text = request.args.get("answer_text")
    answer = PollAnswer(answer=answer_text, poll_id=poll_id)
    db.session.add(answer)
    db.session.commit()
    poll = Poll.query.get(poll_id)
    return render_template("admin/poll-active-list.html", poll=poll)


@current_app.route("/admin/deleteanswer/<answer_id>")
@requires_auth
def delete_answer(answer_id):
    PollAnswer.query.filter(PollAnswer.id == answer_id).delete()
    db.session.commit()
    return ""
