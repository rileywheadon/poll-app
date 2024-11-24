def test_landing(client):
    response = client.get("/")
    assert b"<h1>Welcome to Polll!</h1>" in response.data

