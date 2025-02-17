from flask import redirect, url_for, session
from datetime import datetime
from .db import get_db

# NOTE: Each handler in this file returns a response dictionary

# Gets the response previously submitted by the user
def query_response(poll, user):
    if poll["poll_type"] == "CHOOSE_ONE":
        return query_choose_one(poll, user)
    if poll["poll_type"] == "CHOOSE_MANY":
        return query_choose_many(poll, user)
    if poll["poll_type"] == "NUMERIC_SCALE":
        return query_numeric_scale(poll, user)
    if poll["poll_type"] == "RANKED_POLL":
        return query_ranked_poll(poll, user)
    if poll["poll_type"] == "TIER_LIST":
        return query_tier_list(poll, user)


def query_choose_one(poll, user):

    db = get_db()
    res = (
        db.table("response")
        .select("user_id", "poll_id", "discrete_response(answer_id)")
        .eq("poll_id", poll["id"])
        .eq("user_id", user["id"])
        .order("created_at", desc=True)
        .limit(1)
        .maybe_single()
        .execute()
    )

    if not res:
        return None
    
    response = res.data
    id = response["discrete_response"][0]["answer_id"]
    response["answer"] = poll["answers"][id]["answer"]
    return response


def query_choose_many(poll, user):

    db = get_db()
    res = (
        db.table("response")
        .select("user_id", "poll_id", "discrete_response(answer_id)")
        .eq("poll_id", poll["id"])
        .eq("user_id", user["id"])
        .order("created_at", desc=True)
        .limit(1)
        .maybe_single()
        .execute()
    )

    if not res:
        return None

    response = [] 
    for row in res.data["discrete_response"]: 
        id = row["answer_id"]
        response.append(poll["answers"][id])

    return response


def query_numeric_scale(poll, user):

    db = get_db()
    res = (
        db.table("response")
        .select("user_id", "poll_id", "numeric_response(value)")
        .eq("poll_id", poll["id"])
        .eq("user_id", user["id"])
        .order("created_at", desc=True)
        .limit(1)
        .maybe_single()
        .execute()
    )

    if not res:
        return None
    
    response = res.data
    response["value"] = response["numeric_response"][0]["value"]
    del response["numeric_response"]

    return response


def query_ranked_poll(poll, user):

    db = get_db()
    res = (
        db.table("response")
        .select("user_id", "poll_id", "ranked_response(answer_id, rank)")
        .eq("poll_id", poll["id"])
        .eq("user_id", user["id"])
        .order("created_at", desc=True)
        .limit(1)
        .maybe_single()
        .execute()
    )

    if not res:
        return None
    
    response = [] 
    for row in res.data["ranked_response"]: 
        id = row["answer_id"]
        answer = poll["answers"][id]
        answer["rank"] = row["rank"]
        response.append(answer)

    return response


def query_tier_list(poll, user):

    db = get_db()
    res = (
        db.table("response")
        .select("user_id", "poll_id", "tiered_response(answer_id, tier)")
        .eq("poll_id", poll["id"])
        .eq("user_id", user["id"])
        .order("created_at", desc=True)
        .limit(1)
        .maybe_single()
        .execute()
    )

    if not res:
        return None
    
    response = [] 
    tiers = {1: "S", 2: "A", 3: "B", 4: "C", 5: "D", 6: "F"}
    for row in res.data["tiered_response"]: 
        id = row["answer_id"]
        answer = poll["answers"][id]
        answer["tier"] = tiers[row["tier"]]
        response.append(answer)

    return response


# Creates and adds a response object to the database, returning its ID
def create_response(form, poll):

    # Get arguments for the database operation
    db = get_db()
    user_id = session["user"]["id"]
    poll_id = poll["id"]

    # Insert a new response into the database
    res = db.table("response").insert({
        "user_id": user_id,
        "poll_id": poll_id
    }).execute()

    response_id = res.data[0]["id"]

    # Call the right handler to add the secondary response rows
    if poll["poll_type"] == "CHOOSE_ONE":
        return respond_choose_one(form, poll, response_id)
    if poll["poll_type"] == "CHOOSE_MANY":
        return respond_choose_many(form, poll, response_id)
    if poll["poll_type"] == "NUMERIC_SCALE":
        return respond_numeric_scale(form, poll, response_id)
    if poll["poll_type"] == "RANKED_POLL":
        return respond_ranked_poll(form, poll, response_id)
    if poll["poll_type"] == "TIER_LIST":
        return respond_tier_list(form, poll, response_id)


# Submit a single discrete response to the database
def respond_choose_one(form, poll, response_id):

    # Insert a new discrete_response into the database
    db = get_db()
    answer_id = int(form.get("answer_id")[0])
    data = {"answer_id": answer_id, "response_id": response_id}
    res = db.table("discrete_response").insert(data).execute()
    response = res.data[0]
    
    # Assign the answer string to the response using the cached poll
    response["answer"] = poll["answers"][answer_id]["answer"]
    return response


# Submit multiple discrete responses to the database
def respond_choose_many(form, poll, response_id):

    # Insert new discrete_response objects into the database
    db = get_db()
    answer_ids = [int(id) for id in form.get("answer_id")]
    data = [{"answer_id": id, "response_id": response_id} for id in answer_ids]
    res = db.table("discrete_response").insert(data).execute()
    response = res.data

    # Assign the answer strings to the responses
    for answer, id in zip(response, answer_ids):
        answer["answer"] = poll["answers"][id]["answer"]

    return response
   

# Insert a single numeric repsonse into the database  
def respond_numeric_scale(form, poll, response_id):

    # Insert new numeric_response object into the database
    db = get_db()
    rating = form.get("slider_rating")[0]
    data = {"value": rating, "response_id": response_id}
    res = db.table("numeric_response").insert(data).execute()
    response = res.data[0]
    return response


# Insert a list of ranked responses into the database
def respond_ranked_poll(form, poll, response_id):

    # Create all of the new row objects 
    db = get_db()
    ids = [int(id) for id in form.get("answer_id")]
    ranks = [int(rank) for rank in form.get("answer_rank")]

    # Create the new rows for the database
    data = []
    for id, rank in zip(ids, ranks):
        data.append({"answer_id": id, "response_id": response_id, "rank": rank})

    # Submit all of the new row objects
    res = db.table("ranked_response").insert(data).execute()
    response = res.data

    # Assign the answer strings to the responses and sort by rank
    for row in response:
        id = row["answer_id"]
        row["answer"] = poll["answers"][id]["answer"]

    return sorted(response, key = lambda r: r["rank"])


# Insert a list of tiered responses into the database
def respond_tier_list(form, poll, response_id):

    # Get the answer IDs, tiers, and the the tier score mappings
    db = get_db()
    answer_ids = [int(id) for id in form.get("answer_id")]
    answer_tiers = form.get("answer_tier")
    tiers = {"S": 1, "A": 2, "B": 3, "C": 4, "D": 5, "F": 6}

    # Create the new row objects and add them to the database
    data = []
    for id, tier in zip(answer_ids, answer_tiers):
        data.append({"answer_id": id, "response_id": response_id, "tier": tiers[tier]})

    res = db.table("tiered_response").insert(data).execute()
    response = res.data

    # Assign the answer and tier strings to the responses
    for answer, id in zip(response, answer_ids):
        answer["answer"] = poll["answers"][id]["answer"]
        answer["tier"] = list(tiers.keys())[answer["tier"] - 1]

    return response


