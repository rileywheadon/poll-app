from datetime import datetime

# Helper function to check if a user is on cooldown from making a poll
def on_cooldown(user_dict):

    next_poll_allowed = user_dict["next_poll_allowed"]

    if next_poll_allowed:
        next_poll_time = datetime.strptime(next_poll_allowed, '%Y-%m-%d %H:%M:%S')
        return datetime.utcnow() < next_poll_time

    return False



