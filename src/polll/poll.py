from datetime import datetime
from flask import Blueprint, url_for, session, redirect, render_template

from polll.auth import requires_auth, requires_admin
from polll.db import get_db

# Create a blueprint for the poll endpoints
poll = Blueprint('poll', __name__, template_folder = 'templates')

# Landing page for advertising to potential users
@poll.route("/")
def index():
    return render_template("index.html")


# Home page (empty)
@poll.route("/home")
def home(): 
    return render_template("home.html", user = session["user"])


# Home page (poll feed)
@poll.route("/home/feed")
@requires_auth
def feed():

   # Query the database to get all polls
    polls = db.session.execute(db.select(Poll)).scalars().all()

    # Render the template
    return render_template("home/feed.html", user=current_user, polls=polls, tab='feed')


# Home page (response history)
@poll.route("/home/history")
@requires_auth
def history():

    # Render the template
    return render_template("home/history.html", user=current_user, tab='history')


# Home page (create poll)
@poll.route("/home/create")
@requires_auth
def create():

    # Render the template
    return render_template("home/create.html", user=current_user, tab='create')


# Home page (user's polls)
@poll.route("/home/mypolls")
@requires_auth
def mypolls():

    # Render the template
    return render_template("home/mypolls.html", user=current_user, tab='mypolls')


# HTTP endpoint for responding to polls
@poll.route("/home/respond/<poll_id>", methods=["GET", "POST"])
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
@poll.route("/home/results/<poll_id>", methods=["GET", "POST"])
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



