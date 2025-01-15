from flask import redirect, url_for, session
from datetime import datetime

from polll.db import get_db
import polll.results as result_handlers


# Creates and adds a response object to the database, returning its ID
def create_response(form, poll):

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

    # Insert a new response into the database
    query = """
    INSERT INTO response (user_id, poll_id, timestamp)
    VALUES (?, ?, ?)
    RETURNING id
    """
    values = (user_id, poll_id, timestamp)
    response = cur.execute(query, values)
    response_id = response.fetchone()["id"]

    # Commit to the database, return the ID
    db.commit()
    return response_id


def choose_one(form, poll):

    # Get database connection and add a response
    db = get_db()
    cur = db.cursor()
    response_id = create_response(form, poll)

    # Insert a new discrete_response into the database
    query = """
    INSERT INTO discrete_response (answer_id, response_id)
    VALUES (?, ?)
    """
    answer_id = form.get("answer_id")[0]
    cur.execute(query, (answer_id, response_id))

    # Commit the changes to the database
    db.commit()


def choose_many(form, poll):

    # Get database connection and add a response
    db = get_db()
    cur = db.cursor()
    response_id = create_response(form, poll)

    # Insert new discrete_response objects into the database
    query = """
    INSERT INTO discrete_response (answer_id, response_id)
    VALUES (?, ?)
    """
    answer_ids = form.get("answer_id")
    for answer_id in answer_ids:
        cur.execute(query, (answer_id, response_id))

    # Commit the changes to the database
    db.commit()


def numeric_star(form, poll):

    # Get database connection and add a response
    db = get_db()
    cur = db.cursor()
    response_id = create_response(form, poll)

    # Insert new numeric_response object into the database
    query = """
    INSERT INTO numeric_response (value, response_id)
    VALUES (?, ?)
    """
    rating = form.get("star_rating")[0]
    cur.execute(query, (rating, response_id))

    # Commit the changes to the database
    db.commit()


def numeric_scale(form, poll):

    # Get database connection and add a response
    db = get_db()
    cur = db.cursor()
    response_id = create_response(form, poll)

    # Insert new numeric_response object into the database
    query = """
    INSERT INTO numeric_response (value, response_id)
    VALUES (?, ?)
    """
    rating = form.get("slider_rating")[0]
    cur.execute(query, (rating, response_id))

    # Commit the changes to the database
    db.commit()


def ranked_poll(form, poll):

    # Get database connection and add a response
    db = get_db()
    cur = db.cursor()
    response_id = create_response(form, poll)

    # Insert new ranked_response objects into the database
    query = """
    INSERT INTO ranked_response (answer_id, response_id, rank)
    VALUES (?, ?, ?)
    """
    answer_ids = form.get("answer_id")
    for rank, answer_id in enumerate(answer_ids):
        cur.execute(query, (answer_id, response_id, rank + 1))

    # Commit the changes to the database
    db.commit()


def tier_list(form, poll):

    # Get database connection and add a response
    db = get_db()
    cur = db.cursor()
    response_id = create_response(form, poll)

    # Insert new ranked_response objects into the database
    query = """
    INSERT INTO tiered_response (answer_id, response_id, tier)
    VALUES (?, ?, ?)
    """
    answer_ids = form.get("answer_id")
    answer_tiers = form.get("answer_tier")
    for answer_id, tier in zip(answer_ids, answer_tiers):
        cur.execute(query, (answer_id, response_id, tier))

    # Commit the changes to the database
    db.commit()
