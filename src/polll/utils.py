from flask import request, session
from datetime import datetime, timedelta
from .db import get_db
import base64
import random

import numpy as np
from scipy.stats import gaussian_kde
from datetime import datetime
from dateutil import tz


# Gets some additional information about a poll without making database requests
def query_poll_details(poll):

    if poll["poll_type"] == "NUMERIC_SCALE":

        # Set the left and right endpoints (answers is already ordered by ID) 
        if len(poll["answers"]) == 2:
            poll["answers"] = {"left": poll["answers"][0], "right": poll["answers"][1]}

        # Otherwise set the answers to an empty dictionary
        else:
            poll["answers"] = {}

    # If the poll is not a scale, randomize the answer order
    else:
        answers = random.sample(poll["answers"], len(poll["answers"]))
        poll["answers"] = {a["id"]: a for a in answers}

    # Get the template, custom URL, time string, and comment details
    poll["poll_template"] = poll_template(poll)
    poll["url"] = id_to_url(poll["id"])
    poll["age"] = format_timestamp(poll["created_at"])
    poll["comments"] = {}

    # Return the populated poll dictionary
    return poll


# Gets some additional information about a comment without making database requests
def query_comment_details(comment):
        
    # Set the like count and remove the like field
    comment["like_count"] = comment["like"][0]["count"]
    del comment["like"]

    # Set the dislike count and remove the dislike field
    comment["dislike_count"] = comment["dislike"][0]["count"]
    del comment["dislike"]

    # Set the reply count and remove the reply field
    if not comment["parent_id"]:
        comment["reply_count"] = comment["reply"][0]["count"]
        del comment["reply"]

    # Set the comment age 
    comment["age"] = format_timestamp(comment["created_at"])
    return comment


# Helper function to check if a user is on cooldown from making a poll
def on_cooldown(user_dict):

    next_poll_allowed = user_dict["next_poll_allowed"]

    if next_poll_allowed:
        next_poll_time = datetime.fromisoformat(next_poll_allowed)
        return datetime.now().astimezone() < next_poll_time

    return False


# Get the age of a poll (i.e. 2h or 4d)
def format_timestamp(string):
    timestamp = datetime.fromisoformat(string)
    age = datetime.now().astimezone() - timestamp

    if age.days > 7:
        return f"{age.days // 7}w"
    elif age.days > 0:
        return f"{age.days}d"
    elif age.seconds // 3600 > 0:
        return f"{age.seconds // 3600}h"
    elif age.seconds // 60 > 0:
        return f"{age.seconds // 60}m"
    else:
        return f"{age.seconds}s"


def poll_template(poll):
    template = poll["poll_type"].lower().replace("_", "-")
    return f"polls/{template}.html"


# Helper function to get days behind current time
def get_days_behind(days):
    return (datetime.now() - timedelta(days=days)).astimezone().isoformat()


# Helper functions to encode/decode a poll ID as a URL string
def id_to_url(n):
    hash = ((0x0000FFFF & n) << 16) + ((0xFFFF0000 & n) >> 16)
    code = base64.urlsafe_b64encode(str(hash).encode()).decode()
    return f"{request.scheme}://{request.host}/poll/{code}"


def url_to_id(code):
    hash = int(base64.urlsafe_b64decode(code.encode()).decode())
    return ((0x0000FFFF & hash) << 16) + ((0xFFFF0000 & hash) >> 16)


"""
INPUT:
  - data: the list of dictionaries created for the "scale" poll type
  - bandwidth: bandwidth of the KDE (higher bandwidth => smoother function)

NOTE: bandwdith could be a function of the number of votes

OUTPUT: List of two parallel lists representing (x, y) points 
    e.g. [
        [0, 1, 2, 3, 4, 5], <-- x-vals
        [2, 5, 1, 5, 2, 4]  <-- y-vals
    ]
"""


def smooth_hist(data, bandwidth):
    # Third parameter (must be above 101) helps with local
    # smoothing but anything above 150 casues a noticable
    # drop in performance
    x_vals = np.linspace(0, 100, 501)
    adj_data = [[i["value"]] * i["count"] for i in data]
    adj_data = [i for j in adj_data for i in j]

    # Return a flat chart if there is no data
    if len(data) == 0:
        return [x_vals.tolist(), [0] * 101]

    # If there is data, append one extra point (KDE fails with one point)
    if len(data) == 1:
        adj_data.append(adj_data[0] + 1)
        bandwidth = 10

    # If there are two points, increase the bandwidth to get a smoother graph
    if len(data) == 2:
        bandwidth = 0.5

    return [
        x_vals.tolist(),
        gaussian_kde(adj_data, bw_method=bandwidth)(x_vals).tolist()
    ]


# Formats the given timestamp to be more readable. Also includes the time zone
def format_time(time_string):
    return (datetime
        .fromisoformat(time_string)
        .astimezone()
        .strftime('%b %d, %Y at %I:%M%p')
    )

