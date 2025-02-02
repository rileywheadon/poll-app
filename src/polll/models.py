# NOTE: This file contains database queries for actions that need to be abstracted
# accross multiple endpoints, such as getting poll/comment information

from flask import request, session
from datetime import datetime, timedelta
from polll.db import get_db
import polll.results as result_handlers
import polll.responses as response_handlers
from polll.utils import *
import base64
import time


# Gets some additional information about a poll without making database requests
def query_poll_details(poll):

    # If the poll has its answers attached, reformat them into a dictionary
    poll["answers"] = {a["id"]: a for a in poll["answers"]}

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
