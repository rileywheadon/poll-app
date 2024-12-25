from flask import Blueprint, render_template, redirect, url_for, request, session
from polll.auth import requires_auth, requires_admin
from polll.db import get_db

admin = Blueprint('admin', __name__, template_folder = 'templates')

# Admin endpoint for getting to the editor and responses
@admin.route("/admin")
@requires_admin
def home():
    return render_template("admin.html")


@admin.route("/admin/search")
@requires_admin
def search():

    col = request.args.get("search_column")
    val = "%{}%".format(request.args.get("search_value"))

    db = get_db()
    cur = db.cursor()
    res = cur.execute("SELECT * FROM user WHERE ? LIKE ?", (col, val))
    users = [dict(row) for row in res.fetchall()]
    return render_template("admin/user-list.html", users=users)


@admin.route("/admin/createpoll")
@requires_admin
def createpoll():
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


@admin.route("/admin/deletepoll/<poll_id>")
@requires_admin
def delete_poll(poll_id):
    Poll.query.filter(Poll.id == poll_id).delete()
    PollAnswer.query.filter(PollAnswer.poll_id == poll_id).delete()
    Response.query.filter(Response.poll_id == poll_id).delete()
    db.session.commit()
    return ""


@admin.route("/admin/editpoll/<poll_id>")
@requires_admin
def edit_poll(poll_id):
    poll = Poll.query.get(poll_id)
    return render_template("admin/poll-active.html", poll=poll)


@admin.route("/admin/savepoll/<poll_id>")
@requires_admin
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


@admin.route("/admin/addanswer/<poll_id>")
@requires_admin
def add_answer(poll_id):
    answer_text = request.args.get("answer_text")
    answer = PollAnswer(answer=answer_text, poll_id=poll_id)
    db.session.add(answer)
    db.session.commit()
    poll = Poll.query.get(poll_id)
    return render_template("admin/poll-active-list.html", poll=poll)


@admin.route("/admin/deleteanswer/<answer_id>")
@requires_admin
def delete_answer(answer_id):
    PollAnswer.query.filter(PollAnswer.id == answer_id).delete()
    db.session.commit()
    return ""
