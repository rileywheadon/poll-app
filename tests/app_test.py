from polll.models import User, Poll, PollAnswer, Response

def test_landing(client):
    response = client.get("/")
    assert b"<h1>Welcome to Polll!</h1>" in response.data

def test_home(client, db):
    u = User(username = 'testuser', email = 'test@test.com')
    db.session.add(u)
    db.session.commit()

    response = client.get("/home")
    assert b"<h1>testuser</h1>" in response.data 
    assert b"<h2>test@test.com</h2>" in response.data 


