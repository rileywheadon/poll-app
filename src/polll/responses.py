from flask import render_template, redirect, url_for, request, current_app, session
from flask_login import current_user
from polll.models import *
from polll.decorators import requires_auth


def choose_one(request, poll, user):

    answer_id = request.form.get("answer_id")
    answer = PollAnswer.query.get(answer_id)

    if answer_id is not None:
        response = Response.create(poll=poll, user=user)
        discrete = DiscreteResponse.create(answer=answer, response=response)

    return render_template("polls/choose-one.html", poll=poll)


def choose_many(request, poll, user):

    id_list = request.form.getlist("answer_id")

    if id_list is not None:
        response = Response.create(poll=poll, user=user)
        for id in id_list:
            answer = PollAnswer.query.get(id)
            discrete = DiscreteResponse.create(
                answer=answer, response=response)

    return render_template("polls/choose-many.html", poll=poll)


def numeric_star(request, poll, user):

    rating = request.form.get("star_rating")

    if rating is not None:
        response = Response.create(poll=poll, user=user)
        numeric = NumericResponse.create(value=rating, response=response)

    return render_template("polls/numeric-star.html", poll=poll)


def numeric_scale(request, poll, user):

    rating = request.form.get("slider_rating")

    if rating is not None:
        response = Response.create(poll=poll, user=user)
        numeric = NumericResponse.create(value=rating, response=response)

    return render_template("polls/numeric-scale.html", poll=poll)


def ranked_poll(request, poll, user):

    id_list = request.form.getlist("answer_id")

    if len(id_list) > 0:
        response = Response.create(poll=poll, user=user)
        for idx, id in enumerate(id_list):
            answer = PollAnswer.query.get(id)
            ranked = RankedResponse.create(
                answer=answer,
                response=response,
                rank=idx + 1
            )

    return render_template("polls/ranked-poll.html", poll=poll)


def tier_list(request, poll, user):

    id_list = request.form.getlist("answer_id")
    tr_list = request.form.getlist("answer_tier")

    if len(id_list) > 0:
        response = Response.create(poll=poll, user=user)
        for (id, tr) in zip(id_list, tr_list):
            answer = PollAnswer.query.get(id)
            tiered = TieredResponse.create(
                answer=answer,
                response=response,
                tier=getattr(Tier, tr)
            )
            print(tiered)
        print(response)

    return render_template("polls/tier-list.html", poll=poll)
