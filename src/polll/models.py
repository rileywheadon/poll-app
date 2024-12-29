from datetime import datetime, timedelta

# Helper function to check if a user is on cooldown from making a poll
def on_cooldown(user_dict):

    next_poll_allowed = user_dict["next_poll_allowed"]

    if next_poll_allowed:
        next_poll_time = datetime.strptime(next_poll_allowed, '%Y-%m-%d %H:%M:%S')
        return datetime.utcnow() < next_poll_time

    return False


# Helper functions to add "result_template" and "poll_template" to a poll dictionary
def result_template(poll):
    template = poll["poll_type"].lower().replace("_", "-") 
    return f"results/{template}.html"

def poll_template(poll):
    template = poll["poll_type"].lower().replace("_", "-") 
    return f"polls/{template}.html"


# Helper function to get days behind current time
def get_days_behind(days):
    time = datetime.utcnow() - timedelta(days = days)
    return datetime.strftime(time, '%Y-%m-%d %H:%M:%S')
