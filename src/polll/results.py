from flask import redirect, url_for, render_template, session
from datetime import datetime

from polll.db import get_db


# Helper function to get the user's last response ID.
# If the user or response doesn't exist, return None
RESPONSE_QUERY = """
SELECT timestamp, id
FROM response
WHERE response.poll_id = ? AND response.user_id = ?
ORDER BY timestamp DESC
"""


def get_response(poll_id, user):
    if not user:
        return None

    db = get_db()
    cur = db.cursor()
    res = cur.execute(RESPONSE_QUERY, (poll_id, user["id"])).fetchone()
    return res["id"] if res else None


DISCRETE_RESULTS = """
SELECT
    poll_answer.id AS answer_id,
    poll_answer.answer AS answer,
    COUNT(discrete_response.id) AS count
FROM poll_answer
    LEFT JOIN discrete_response ON discrete_response.answer_id = poll_answer.id
WHERE poll_answer.poll_id = ?
GROUP BY poll_answer.id
"""

DISCRETE_RESPONSE = """
SELECT
    poll_answer.id AS answer_id,
    poll_answer.answer AS answer
FROM discrete_response
    INNER JOIN poll_answer ON poll_answer.id = discrete_response.answer_id
WHERE discrete_response.response_id = ?
"""


def choose_one(poll_id, user):

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the poll answer counts
    res = cur.execute(DISCRETE_RESULTS, (poll_id,))
    results = [dict(result) for result in res.fetchall()]

    # Get the user's last response, if possible
    response = {}
    response_id = get_response(poll_id, user)
    if response_id:
        res = cur.execute(DISCRETE_RESPONSE, (response_id,))
        response = dict(res.fetchone())

    # Return the results
    print("RESULTS:", results)
    print("RESPONSE:", response)
    return (results, response)


def choose_many(poll_id, user):

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the poll answer counts
    res = cur.execute(DISCRETE_RESULTS, (poll_id,))
    results = [dict(result) for result in res.fetchall()]

    # Get the user's last response, if possible
    response = {}
    response_id = get_response(poll_id, user)
    if response_id:
        res = cur.execute(DISCRETE_RESPONSE, (response_id,))
        response = [dict(result) for result in res.fetchall()]

    # Return the results
    print("RESULTS:", results)
    print("RESPONSE:", response)
    return (results, response)


NUMERIC_RESULT = """
SELECT
    numeric_response.value AS value,
    COUNT(numeric_response.id) AS count
FROM response
    INNER JOIN numeric_response ON numeric_response.response_id = response.id
WHERE response.poll_id = ?
GROUP BY numeric_response.value
"""

NUMERIC_RESPONSE = """
SELECT numeric_response.value AS value
FROM response
    INNER JOIN numeric_response ON numeric_response.response_id = response.id
WHERE response.id + ?
"""


def numeric_star(poll_id, user):

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the answer counts
    res = cur.execute(NUMERIC_RESULT, (poll_id,))
    results = [dict(result) for result in res.fetchall()]

    # Get the user's last response, if possible
    response = {}
    response_id = get_response(poll_id, user)
    if response_id:
        res = cur.execute(NUMERIC_RESPONSE, (response_id,))
        response = dict(res.fetchone())

    # Return the results
    print("RESULTS:", results)
    print("RESPONSE:", response)
    return (results, response)


def numeric_scale(poll_id, user):

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the answer counts
    res = cur.execute(NUMERIC_RESULT, (poll_id,))
    results = [dict(result) for result in res.fetchall()]

    # Get the user's last response, if possible
    response = {}
    response_id = get_response(poll_id, user)
    if response_id:
        res = cur.execute(NUMERIC_RESPONSE, (response_id,))
        response = dict(res.fetchone())

    # Return the results
    print("RESULTS:", results)
    print("RESPONSE:", response)
    return (results, response)


RANKED_RESULT = """
SELECT
    poll_answer.id AS answer_id,
    poll_answer.answer AS answer,
    SUM(ranked_response.rank) AS score
FROM ranked_response
    INNER JOIN poll_answer ON poll_answer.id = ranked_response.answer_id
WHERE ranked_response.response_id IN (
    SELECT id
    FROM response
    WHERE response.poll_id = ?
)
GROUP BY poll_answer.id
ORDER BY score ASC
"""

RANKED_RESPONSE = """
SELECT
    poll_answer.id AS answer_id,
    poll_answer.answer AS answer,
    ranked_response.rank AS rank
FROM ranked_response
    INNER JOIN poll_answer ON poll_answer.id = ranked_response.answer_id
WHERE ranked_response.response_id = ?
ORDER BY rank ASC
"""


def ranked_poll(poll_id, user):

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the answer counts
    res = cur.execute(RANKED_RESULT, (poll_id,)).fetchall()
    results = [dict(result) for result in res]

    # Get the user's response (if necessary)
    response = {}
    response_id = get_response(poll_id, user)
    if response_id:
        res = cur.execute(RANKED_RESPONSE, (response_id,))
        response = [dict(result) for result in res.fetchall()]

    # Return the results
    print("RESULTS:", results)
    print("RESPONSE:", response)
    return (results, response)


TIERS = ["S", "A", "B", "C", "D", "F"]

TIER_RESULT_A = """
SELECT *
FROM poll_answer
WHERE poll_id = ?
"""

TIER_RESULT_B = """
SELECT COUNT(tiered_response.id) as count
FROM tiered_response
WHERE tiered_response.answer_id = ? AND tiered_response.tier = ?
"""

TIER_RESPONSE = """
SELECT
    poll_answer.id AS answer_id,
    poll_answer.answer AS answer,
    tiered_response.tier AS tier
FROM tiered_response
    LEFT JOIN poll_answer ON poll_answer.id = tiered_response.answer_id
WHERE tiered_response.response_id = ?
"""


def tier_list(poll_id, user):

    # Connect to the database
    db = get_db()
    cur = db.cursor()

    # Query the database to get the list of answers to this tier list
    res = cur.execute(TIER_RESULT_A, (poll_id,)).fetchall()
    results = [dict(result) for result in res]

    # Get count data for each answer
    for answer in results:

        # Set the counts for each (tier, answer) pair
        for tier in TIERS:
            res = cur.execute(TIER_RESULT_B, (answer["id"], tier)).fetchone()
            answer[tier] = res["count"] if res else 0

    # Get the user's response (if necessary)
    response = {}
    response_id = get_response(poll_id, user)
    if response_id:
        res = cur.execute(TIER_RESPONSE, (response_id,))
        response = [dict(result) for result in res.fetchall()]

    # Return the results
    print("RESULTS:", results)
    print("RESPONSE:", response)
    return (results, response)
