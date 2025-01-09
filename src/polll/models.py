from flask import request
from datetime import datetime, timedelta
import base64


# Helper function to check if a user is on cooldown from making a poll
def on_cooldown(user_dict):

    next_poll_allowed = user_dict["next_poll_allowed"]

    if next_poll_allowed:

        next_poll_time = datetime.strptime(
            next_poll_allowed,
            '%Y-%m-%d %H:%M:%S'
        )

        return datetime.utcnow() < next_poll_time

    return False


# Get the age of a poll (i.e. 2h or 4d)
def get_poll_age(poll):
    timestamp = datetime.strptime(poll["date_created"], '%Y-%m-%d %H:%M:%S')
    age = datetime.utcnow() - timestamp

    if age.days > 0:
        return f"{age.days}d"
    elif age.seconds // 3600 > 0:
        return f"{age.seconds // 3600}h"
    elif age.seconds // 60 > 0:
        return f"{age.seconds // 60}m"
    else:
        return f"{age.seconds}s"


# Helper functions to add "result_template" and "poll_template" to a poll dictionary
def result_template(poll):
    template = poll["poll_type"].lower().replace("_", "-")
    return f"results/{template}.html"


def poll_template(poll):
    template = poll["poll_type"].lower().replace("_", "-")
    return f"polls/{template}.html"


# Helper function to get days behind current time
def get_days_behind(days):
    time = datetime.utcnow() - timedelta(days=days)
    return datetime.strftime(time, '%Y-%m-%d %H:%M:%S')


# Helper functions to encode/decode a poll ID as a URL string
def id_to_url(n):
    hash = ((0x0000FFFF & n) << 16) + ((0xFFFF0000 & n) >> 16)
    code = base64.urlsafe_b64encode(str(hash).encode()).decode()
    return f"{request.scheme}://{request.host}/poll/{code}"


def url_to_id(code):
    hash = int(base64.urlsafe_b64decode(code.encode()).decode())
    return ((0x0000FFFF & hash) << 16) + ((0xFFFF0000 & hash) >> 16)
