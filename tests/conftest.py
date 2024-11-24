import pytest
from polll import app, db
from polll.models import *

@pytest.fixture()
def client():
    app.config["TESTING"] = True
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///test.db"

    # Create the app and database
    with app.app_context():
        db.create_all()
        yield app.test_client()
        db.drop_all()

