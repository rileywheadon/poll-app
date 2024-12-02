
from flask import render_template, redirect, url_for, request, current_app, session
from flask_login import current_user
from polll.models import *
from polll.decorators import requires_auth

def choose_one(request, poll):

    return render_template("results/choose-one.html", poll = poll)

def choose_many(request, poll):

    return render_template("results/choose-many.html", poll = poll)

def numeric_star(request, poll):

    return render_template("results/numeric-star.html", poll = poll)

def numeric_scale(request, poll):

    return render_template("results/numeric-scale.html", poll = poll)

def ranked_poll(request, poll):

    return render_template("results/ranked-poll.html", poll = poll)

def tier_list(request, poll):

    return render_template("results/tier-list.html", poll = poll)
