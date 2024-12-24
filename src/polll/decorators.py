from flask import redirect, session, url_for
from flask_login import current_user
from functools import wraps

class AuthError(Exception):
    def __init__(self, error, status_code):
        self.error = error
        self.status_code = status_code

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if current_user.is_anonymous:
            return redirect(url_for('auth.login'))

        return f(*args, **kwargs)

    return decorated

def requires_admin(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if current_user.is_anonymous:
            return redirect(url_for('auth.login'))

        elif current_user.email != "admin@polll.org":
            return redirect(url_for('home'))

        return f(*args, **kwargs)

    return decorated
