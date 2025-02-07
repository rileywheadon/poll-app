from datetime import datetime, timedelta
import time
import asyncio

from flask import Blueprint, url_for, session, redirect
from flask import render_template, request, make_response

from .auth import requires_auth, requires_admin
from .utils import *
from .db import get_db


# Create a blueprint for the poll endpoints
home = Blueprint('home', __name__, template_folder='templates')

# Maixmimum number of polls loaded at once
POLL_LIMIT = 10

# Conversion of cutoff periods to days
CUTOFF_PERIODS = {
    "day": 1,
    "week": 7,
    "month": 30,
    "year": 365,
    "all": 10000
}


# Route for opening the settings window
@home.route("/settings/open")
@requires_auth
def open_settings():
    current_url = request.headers.get("HX-Current-Url")
    root_url = request.url_root

    # Remove the url (i.e. polll.org), and the query params
    return_endpoint = current_url.replace(root_url, "").split("?")[0]
    return_url = url_for(f"home.{return_endpoint}")
    return render_template("settings.html", session=session, return_url=return_url)


# Route for updating settings (just username at the moment)
@home.route("/settings/save")
@requires_auth
def save_settings():
    db = get_db()
    username = request.args.get("username")

    # Check that username is nonempty
    if not username:
        r = make_response("")
        notification = '{"notification": "Name cannot be empty!"}'
        r.headers.set("HX-Trigger", notification)
        return r

    # Check that the username is different from the user's current name
    if username == session["user"]["username"]:
        return ""

    # Check if the username the user wants is already taken
    res = db.table("user").select("*").eq("username", username).execute()
    unique = len(res.data) == 0
    notification = None

    # If the new username is unique, assign it to the user
    if unique:
        notification = '{"notification": "Name Changed!"}'
        session["user"]["username"] = username
        id = session["user"]["id"]
        db.table("user").update({"username": username}).eq("id", id).execute()

    # Otherwise notify the user that an error occured
    else:
        notification = '{"notification": "Name Taken!"}'

    # Send a notification to the user and return
    session.modified = True
    r = make_response("")
    r.headers.set("HX-Trigger", notification)
    return r


# Helper function to call the correct feed RPC handler
def query_feed(bid, order, period, page):
    res = None
    db = get_db()
    uid = session["user"]["id"]

    args = {"bid": bid, "uid": uid, "page": page, "lim": POLL_LIMIT}

    if order == "hot":
        res = db.rpc("feed_hot", args).execute()
    if order == "top":
        cutoff = get_days_behind(CUTOFF_PERIODS[period])
        session["state"]["cutoff"] = cutoff
        args["cutoff"] = cutoff
        res = db.rpc("feed_top", args).execute()
    if order == "new":
        res = db.rpc("feed_new", args).execute()

    return res


# Home page (poll feed). The board/order is optional (set to All/hot by default)
@home.route("/feed")
@requires_auth
def feed():

    # Get the request arguments (board and order) and query the database
    bid = request.args.get("board") or 1
    order = request.args.get("order") or "hot"
    period = request.args.get("period") or "day"
    res = query_feed(bid, order, period, 0)

    # Update the session state variable and render the feed
    session["polls"] = {p["id"]: query_poll_details(p) for p in res.data}
    session["comments"] = {}
    session["replies"] = {}

    session["state"].update({
        "admin": False,
        "tab": "feed",
        "poll_page": 0,
        "poll_full": len(res.data) < POLL_LIMIT,
        "board": session["boards"].get(int(bid)) or {},
        "order": order,
        "period": period,
    })

    return render_template("home/feed.html", session=session)


# Home page (create poll)
@home.route("/create")
@requires_auth
def create():

    # Sort the boards by primary first
    boards = session["boards"].items()
    boards = sorted(boards, key = lambda b : b[1]["primary"], reverse=True)
    session["boards"] = dict(boards)

    # Update the session state variable and render the feed
    session["user"]["on_cooldown"] = on_cooldown(session["user"])
    session["state"] = {"admin": False, "tab": "create"}

    # Render the HTML template
    return render_template("home/create.html", session=session)


# Create a new poll answer entry box. This is simpler than writing javascript.
@home.route("/create/answer")
@requires_auth
def create_answer():
    return render_template("home/create-answer.html")


# Create a new poll
@home.route("/create/poll")
@requires_auth
def create_poll():

    # Get request data for creating the poll
    creator_id = session["user"]["id"]
    question = request.args.get("poll_question")
    poll_type = request.args.get("poll_type")
    endpoint_left = request.args.get("endpoint_left")
    endpoint_right = request.args.get("endpoint_right")
    is_anonymous = 1 if request.args.get("poll_anonymous") else 0

    # Get request data for creating the answer and poll_board connections
    answers = request.args.getlist("poll_answer")
    board_ids = request.args.getlist("poll_board")

    # Check that the question and answers are not empty
    numeric = poll_type in ["NUMERIC_STAR", "NUMERIC_SCALE"]
    if question == "" or (any([a == "" for a in answers]) and not numeric):
        r = make_response("")
        notification = '{"notification": "Question/answers cannot be empty!"}'
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", 'none')
        return r

    # Check that the answers do not contain duplicates
    if len(set(answers)) < len(answers) and not numeric:
        r = make_response("")
        notification = '{"notification": "Answers cannot have duplicates!"}'
        r.headers.set("HX-Trigger", notification)
        r.headers.set("HX-Reswap", 'none')
        return r

    # Add the poll to the database
    poll_data = {
        "creator_id": creator_id,
        "question": question,
        "poll_type": poll_type,
        "is_anonymous": is_anonymous,
    }

    db = get_db()
    res = db.table("poll").insert(poll_data).execute()
    poll_id = res.data[0]["id"]

    # Assign the boards to the poll
    board_data = [{"poll_id": poll_id, "board_id": id} for id in board_ids]
    res = db.table("poll_board").insert(board_data).execute()

    # Add the poll answers to the database unless they are numeric
    if not numeric:
        answer_data = [{"poll_id": poll_id, "answer": a} for a in answers]
        res = db.table("answer").insert(answer_data).execute()

    # If the poll is numeric, attempt to add the endpoints
    if numeric and endpoint_left and endpoint_right:
        endpoints = [
            {"poll_id": poll_id, "answer": endpoint_left},
            {"poll_id": poll_id, "answer": endpoint_right}
        ]
        res = db.table("answer").insert(endpoints).execute()

    # Update the last poll created time for the user
    user_id = session["user"]["id"]
    last_poll_time = datetime.now()
    next_poll_time = last_poll_time

    # If the user is not an administrator, increment next_poll_allowed by one day
    if not session["user"]["is_admin"]:
        next_poll_time += timedelta(days=1)

    # Update the current user's information in the database
    last_poll_created = last_poll_time.astimezone().isoformat()
    next_poll_allowed = next_poll_time.astimezone().isoformat()
    res = db.table("user").update({
        "last_poll_created": last_poll_created,
        "next_poll_allowed": next_poll_allowed
    }).eq("id", creator_id).execute()

    # Update the current user's information in the session
    session["user"]["last_poll_created"] = last_poll_created
    session["user"]["next_poll_allowed"] = next_poll_allowed
    session["user"]["on_cooldown"] = on_cooldown(session["user"])
    session.modified = True

    # Render the create.html template, while triggering a notification
    template = render_template("home/create-card.html", session=session)
    r = make_response(template)
    notification = '{"notification": "Poll Submitted!"}'
    r.headers.set("HX-Trigger", notification)
    return r


# Home page (user's polls)
@home.route("/mypolls")
@requires_auth
def mypolls():

    # Query the database for all polls made by the user
    db = get_db()
    user = session["user"]
    data = {"cid": user["id"], "page": 0, "lim": POLL_LIMIT}
    res = db.rpc("mypolls", data).execute()

    # Update the session object with the new state
    session["comments"] = {}
    session["replies"] = {}
    session["polls"] = {p["id"]:query_poll_details(p) for p in res.data}

    session["state"] = {
        "admin": False,
        "tab": "mypolls",
        "poll_page": 0,
        "poll_full": len(res.data) < POLL_LIMIT
    }

    # Render the HTML template
    session.modified = True
    return render_template("home/mypolls.html", session=session)


# Home page (response history)
@home.route("/history")
@requires_auth
def history():

    # Query the database for all polls responded to by the user
    db = get_db()
    user = session["user"]
    data = {"uid": user["id"], "page": 0, "lim": POLL_LIMIT}
    res = db.rpc("history", data).execute()

    # Set data on the session object
    session["comments"] = {}
    session["replies"] = {}
    session["polls"] = {p["id"]:query_poll_details(p) for p in res.data}

    session["state"] = {
        "admin": False, 
        "tab": "history",
        "poll_page": 0,
        "poll_full": len(res.data) < POLL_LIMIT
    }

    # Render the HTML template
    session.modified = True
    return render_template("home/history.html", session=session)


# Render more polls in the history tab
@home.route("/load/<origin>/<page>")
@requires_auth
def load_more(origin, page):

    # Query the database with the correct offset given by page + 1
    db = get_db()
    user = session["user"]
    page = int(page) + 1

    # Modify the RPC call depending on the origin
    res = None
    if origin == "feed":
        bid = session["state"]["board"]["id"]
        order = session["state"]["order"]
        period = session["state"]["period"]
        res = query_feed(bid, order, period, page)
    if origin == "history":
        args = {"uid": user["id"], "page": page, "lim": POLL_LIMIT}
        res = db.rpc("history", args).execute()
    if origin == "mypolls":
        args = {"cid": user["id"], "page": page, "lim": POLL_LIMIT}
        res = db.rpc("mypolls", args).execute()

    # Add the new polls to the polls dictionary
    polls = {p["id"]: query_poll_details(p) for p in res.data}

    # Update the session state
    session["polls"].update(polls)
    session["state"]["poll_page"] = page
    session["state"]["poll_full"] = len(res.data) < POLL_LIMIT

    # Render the HTML template
    session.modified = True
    state = session["state"]
    return render_template("home/load-response.html", state=state, polls=polls)


