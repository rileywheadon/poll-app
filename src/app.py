from polll import create_app
from os import environ as env
from dotenv import find_dotenv, load_dotenv

# Load the .env file, if it exists
ENV_FILE = find_dotenv()
if ENV_FILE:
    load_dotenv(ENV_FILE)

# Create and run the app
app = create_app()
if __name__ == "__main__":
    app.run(
        host='0.0.0.0',
        port=env.get("PORT", 3000),
        ssl_context=('cert.pem', 'key.pem'),
        debug=True
    )
