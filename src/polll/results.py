from flask import redirect, url_for, render_template, session
from datetime import datetime
from polll.db import get_db
from polll.utils import smooth_hist

# NOTE: These get the aggregate results of the poll (NOT the user's response)

def query_results(poll):
    if poll["poll_type"] == "CHOOSE_ONE":
        return choose_one(poll)
    if poll["poll_type"] == "CHOOSE_MANY":
        return choose_many(poll)
    if poll["poll_type"] == "NUMERIC_SCALE":
        return numeric_scale(poll)
    if poll["poll_type"] == "RANKED_POLL":
        return ranked_poll(poll)
    if poll["poll_type"] == "TIER_LIST":
        return tier_list(poll)


def choose_one(poll):

    # Query the database to get the answer counts
    db = get_db()
    res = (
        db.table("answer")
        .select("id, answer, discrete_response!inner(count)")
        .eq("poll_id", poll["id"])
        .execute()
    )

    # Reformat the data so its easier to parse in graphs.js
    result = res.data
    for answer in result:
        answer["count"] = answer["discrete_response"][0]["count"]
        del answer["discrete_response"]

    return result


def choose_many(poll):

    # Query the database to get the answer counts
    db = get_db()
    res = (
        db.table("answer")
        .select("id, answer, discrete_response!inner(count)")
        .eq("poll_id", poll["id"])
        .execute()
    )

    # Reformat the data so its easier to parse in graphs.js
    result = res.data
    for answer in result:
        answer["count"] = answer["discrete_response"][0]["count"]
        del answer["discrete_response"]

    return result


def numeric_scale(poll):

    # Query the database to get the value counts
    db = get_db()
    res = (
        db.table("numeric_response")
        .select("count(),value,response!inner(poll_id)")
        .eq("response.poll_id", poll["id"])
        .execute()
    )
    result = res.data

    # Remove the poll_id from the response
    for value in result:
        del value["response"]

    return result


def ranked_poll(poll):

    # Query the database to get the answer counts
    db = get_db()
    res = (
        db.table("ranked_response")
        .select("rank.sum(),answer_id,response!inner(poll_id)") 
        .eq("response.poll_id", poll["id"])
        .execute()
    )

    # Order the results by sum, remove unnecessary fields, add poll answers
    result = sorted(res.data, key = lambda r: r["sum"])

    for answer in result:
        id = answer["answer_id"]
        answer["answer"] = poll["answers"][int(id)]["answer"]
        del answer["response"]

    return result



def tier_list(poll):

    # Query the database to get the answer counts
    db = get_db()
    res = (
        db.table("tiered_response")
        .select("tier.count(),tier.sum(),answer_id,response!inner(poll_id)") 
        .eq("response.poll_id", poll["id"])
        .execute()
    )
    
    # Reconstruct the average tier, remove unnecessary fields, add poll answers
    result = res.data
    tiers = {1: "S", 2: "A", 3: "B", 4: "C", 5: "D", 6: "F"}

    for answer in result:
        avg = round(answer["sum"] / answer["count"])
        answer["tier"] = tiers[avg]
        id = answer["answer_id"]
        answer["answer"] = poll["answers"][id]["answer"]
        del answer["response"]

    return result
