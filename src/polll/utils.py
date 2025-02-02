from flask import request, session
from datetime import datetime, timedelta
from polll.db import get_db
import base64

import numpy as np
from scipy.stats import gaussian_kde
from datetime import datetime
from dateutil import tz


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

    if age.days > 0:
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


# Helper function to get how "trendy" a poll is, in responses/second
def popularity(poll):
    timestamp = datetime.strptime(poll["created_at"], '%Y-%m-%d %H:%M:%S')
    age = (datetime.utcnow() - timestamp).total_seconds()
    return poll["response_count"] / age


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
    x_vals = np.linspace(0, 100, 101)
    adj_data = [[i["value"]] * i["count"] for i in data]
    adj_data = [i for j in adj_data for i in j]

    # Return a flat chart if there is no data
    if len(data) == 0:
        return [x_vals.tolist(), [0] * 101]

    # If there is data, append one extra point (KDE fails with one point)
    if len(data) == 1:
        adj_data.append(adj_data[0] + 1)
        bandwidth = 10

    return [
        x_vals.tolist(),
        gaussian_kde(adj_data, bw_method=bandwidth)(x_vals).tolist()
    ]


# Formats the given timestamp to be more readable as well as converts it to the user's local timezone
def format_time(time_string):
    locale = str(datetime.strptime(time_string, "%Y-%m-%d %H:%M:%S").replace(
        tzinfo=tz.tzutc()).astimezone(tz.tzlocal()))
    locale = locale[:locale.rindex("-")]
    dates = list(map(int, locale[:time_string.index(" ")].split("-")))
    times = list(map(int, locale[1 + time_string.index(" "):].split(":")))
    return datetime(dates[0], dates[1], dates[2], times[0], times[1], times[2]).strftime("%a %d, %I:%M %p") + " " + str(datetime.now().astimezone().tzinfo)
