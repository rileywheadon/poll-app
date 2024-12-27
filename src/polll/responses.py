# NOTE: These functions handle submitting responses to the database

from flask import redirect, url_for, session, request
from datetime import datetime

from polll.db import get_db
import polll.results as result_handlers


def choose_one(request, poll):
    print("In response_handlers.choose_one")

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation 
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    answer_id = request.form.get("answer_id")

    # Insert a new response into the database
    query = """
    INSERT INTO response (user_id, poll_id, timestamp)
    VALUES (?, ?, ?)
    RETURNING id
    """
    values = (user_id, poll_id, timestamp)
    response = cur.execute(query, values)
    response_id = response.fetchone()["id"]

    # Insert a new discrete_response into the database
    query = """
    INSERT INTO discrete_response (answer_id, response_id)
    VALUES (?, ?)
    """
    values = (answer_id, response_id)
    cur.execute(query, values)

    # Commit the changes to the database 
    db.commit()


def choose_many(request, poll):
    print("In response_handlers.choose_many")

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation 
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    answer_ids = request.form.getlist("answer_id")

    # Insert a new response into the database
    query = """
    INSERT INTO response (user_id, poll_id, timestamp)
    VALUES (?, ?, ?)
    RETURNING id
    """
    values = (user_id, poll_id, timestamp)
    response = cur.execute(query, values)
    response_id = response.fetchone()["id"]

    # Insert new discrete_response objects into the database
    query = """
    INSERT INTO discrete_response (answer_id, response_id)
    VALUES (?, ?)
    """
    for answer_id in answer_ids:
        values = (answer_id, response_id)
        cur.execute(query, values)

    # Commit the changes to the database 
    db.commit()


def numeric_star(request, poll):
    print("In response_handlers.numeric_star")

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation 
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    rating = request.form.get("star_rating")

    # Insert a new response into the database
    query = """
    INSERT INTO response (user_id, poll_id, timestamp)
    VALUES (?, ?, ?)
    RETURNING id
    """
    values = (user_id, poll_id, timestamp)
    response = cur.execute(query, values)
    response_id = response.fetchone()["id"]

    # Insert new numeric_response object into the database
    query = """
    INSERT INTO numeric_response (value, response_id)
    VALUES (?, ?)
    """
    values = (rating, response_id)
    cur.execute(query, values)

    # Commit the changes to the database 
    db.commit()


def numeric_scale(request, poll):
    print("In response_handlers.numeric_scale")

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation 
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    rating = request.form.get("slider_rating")

    # Insert a new response into the database
    query = """
    INSERT INTO response (user_id, poll_id, timestamp)
    VALUES (?, ?, ?)
    RETURNING id
    """
    values = (user_id, poll_id, timestamp)
    response = cur.execute(query, values)
    response_id = response.fetchone()["id"]

    # Insert new numeric_response object into the database
    query = """
    INSERT INTO numeric_response (value, response_id)
    VALUES (?, ?)
    """
    values = (rating, response_id)
    cur.execute(query, values)

    # Commit the changes to the database 
    db.commit()


def ranked_poll(request, poll):
    print("In response_handlers.ranked_poll")

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation 
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    answer_ids = request.form.getlist("answer_id")

    # Insert a new response into the database
    query = """
    INSERT INTO response (user_id, poll_id, timestamp)
    VALUES (?, ?, ?)
    RETURNING id
    """
    values = (user_id, poll_id, timestamp)
    response = cur.execute(query, values)
    response_id = response.fetchone()["id"]

    # Insert new ranked_response objects into the database
    query = """
    INSERT INTO ranked_response (answer_id, response_id, rank)
    VALUES (?, ?, ?)
    """
    for rank, answer_id in enumerate(answer_ids):
        values = (answer_id, response_id, rank + 1)
        cur.execute(query, values)

    # Commit the changes to the database 
    db.commit()



def tier_list(request, poll):
    print("In response_handlers.tier_list")

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation 
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    answer_ids = request.form.getlist("answer_id")
    answer_tiers = request.form.getlist("answer_tier")

    # Insert a new response into the database
    query = """
    INSERT INTO response (user_id, poll_id, timestamp)
    VALUES (?, ?, ?)
    RETURNING id
    """
    values = (user_id, poll_id, timestamp)
    response = cur.execute(query, values)
    response_id = response.fetchone()["id"]

    # Insert new ranked_response objects into the database
    query = """
    INSERT INTO tiered_response (answer_id, response_id, tier)
    VALUES (?, ?, ?)
    """
    for answer_id, tier in zip(answer_ids, answer_tiers):
        values = (answer_id, response_id, tier)
        cur.execute(query, values)

    # Commit the changes to the database 
    db.commit()

