# NOTE: These functions handle getting poll results from the database

from flask import redirect, url_for, render_template, session
from datetime import datetime

from polll.db import get_db


def choose_one(poll_id):
    print("In result_handlers.choose_one")

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the poll answer counts
    query = """
    SELECT 
        poll_answer.id AS answer_id,
        poll_answer.answer AS answer,
        COUNT(discrete_response.id) AS count
    FROM poll
        INNER JOIN poll_answer ON poll_answer.poll_id = poll.id
        LEFT JOIN discrete_response ON discrete_response.answer_id = poll_answer.id 
    WHERE poll.id = ?
    GROUP BY poll_answer.id
    """
    res = cur.execute(query, (poll_id,)).fetchall()
    results = [dict(result) for result in res]

    # Return the results
    return results


def choose_many(poll_id):
    print("In result_handlers.choose_many")

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the poll answer counts
    query = """
    SELECT 
        poll_answer.id AS answer_id,
        poll_answer.answer AS answer,
        COUNT(discrete_response.id) AS count
    FROM poll
        INNER JOIN poll_answer ON poll_answer.poll_id = poll.id
        LEFT JOIN discrete_response ON discrete_response.answer_id = poll_answer.id 
    WHERE poll.id = ?
    GROUP BY poll_answer.id
    """
    res = cur.execute(query, (poll_id,)).fetchall()
    results = [dict(result) for result in res]

    # Return the results
    return results


def numeric_star(poll_id):
    print("In result_handlers.numeric_star")

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the answer counts
    query = """
    SELECT 
        numeric_response.value AS value,
        COUNT(numeric_response.id) AS count
    FROM poll
        INNER JOIN response ON response.poll_id = poll.id
        INNER JOIN numeric_response ON numeric_response.response_id = response.id 
    WHERE poll.id = ?
    GROUP BY numeric_response.value
    """
    res = cur.execute(query, (poll_id,)).fetchall()
    results = [dict(result) for result in res]

    # Return the results
    return results


def numeric_scale(poll_id):
    print("In result_handlers.numeric_scale")

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the answer counts
    query = """
    SELECT 
        numeric_response.value AS value,
        COUNT(numeric_response.id) AS count
    FROM poll
        INNER JOIN response ON response.poll_id = poll.id
        INNER JOIN numeric_response ON numeric_response.response_id = response.id 
    WHERE poll.id = ?
    GROUP BY numeric_response.value
    """
    res = cur.execute(query, (poll_id,)).fetchall()
    results = [dict(result) for result in res]

    # Return the results
    return results


def ranked_poll(poll_id):
    print("In result_handlers.ranked_poll")

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the answer counts
    query = """
    SELECT 
        poll_answer.id AS answer_id,
        poll_answer.answer AS answer,
        ranked_response.rank AS rank,
        COUNT(ranked_response.id) AS count
    FROM poll
        INNER JOIN poll_answer ON poll_answer.poll_id = poll.id
        LEFT JOIN ranked_response ON ranked_response.answer_id = poll_answer.id 
    WHERE poll.id = ?
    GROUP BY 
        ranked_response.rank,
        poll_answer.id
    """
    res = cur.execute(query, (poll_id,)).fetchall()
    results = [dict(result) for result in res]

    # Return the results
    return results


def tier_list(poll_id):
    print("In result_handlers.tier_list")

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the answer counts
    query = """
    SELECT 
        poll_answer.id AS answer_id,
        poll_answer.answer AS answer,
        tiered_response.tier AS tier,
        COUNT(tiered_response.id) AS count
    FROM poll
        INNER JOIN poll_answer ON poll_answer.poll_id = poll.id
        LEFT JOIN tiered_response ON tiered_response.answer_id = poll_answer.id 
    WHERE poll.id = ?
    GROUP BY 
        tiered_response.tier,
        poll_answer.id
    """
    res = cur.execute(query, (poll_id,)).fetchall()
    results = [dict(result) for result in res]

    # Return the results
    return results
