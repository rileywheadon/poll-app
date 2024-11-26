import pytest
from polll import create_app
from polll.models import User, Poll, PollAnswer, Response

# Create a session-wide application for testing
@pytest.fixture(scope = "session")
def app():
    app = create_app(True)
    app.config.update({"TESTING": True})
    return app


# Create an app context for each test
@pytest.fixture(autouse = True)
def app_context(app, request):
    context = app.app_context()
    context.push()
    yield
    context.pop()


# Returns the session-wide database
@pytest.fixture(scope = "session")
def db(app):
    from polll.models import db as _db
    with app.app_context():
        _db.create_all()
        yield _db
        _db.drop_all()


# Yields the test client
@pytest.fixture
def client(app):
    return app.test_client()
