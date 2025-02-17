import os

from polll import create_app
from dotenv import find_dotenv, load_dotenv

# Load the .env file, if it exists
ENV_FILE = find_dotenv()
print("\n\n\n")
print(ENV_FILE)
print("\n\n\n")
if ENV_FILE:
    load_dotenv(ENV_FILE)

# Create and run the app
app = create_app()
if __name__ == "__main__":
    app.run(
        host='0.0.0.0',
        port=os.environ.get("PORT", 3000),
        ssl_context=('cert.pem', 'key.pem'),
        debug=True
    )
