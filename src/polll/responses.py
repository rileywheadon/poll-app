# NOTE: These functions handle submitting responses to the database

from flask import redirect, url_for, session
from datetime import datetime

from polll.db import get_db
import polll.results as result_handlers


def choose_one(form, poll):

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    answer_id = form.get("answer_id")[0]

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


def choose_many(form, poll):

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    answer_ids = form.get("answer_id")

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


def numeric_star(form, poll):

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    rating = form.get("star_rating")[0]

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


def numeric_scale(form, poll):

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    rating = form.get("slider_rating")[0]

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


def ranked_poll(form, poll):

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    answer_ids = form.get("answer_id")

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


def tier_list(form, poll):

    # Get database connection
    db = get_db()
    cur = db.cursor()

    # Get arguments for the database operation
    user_id = session["user"]["id"]
    poll_id = poll["id"]
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    answer_ids = form.get("answer_id")
    answer_tiers = form.get("answer_tier")

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
