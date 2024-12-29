# polll

## Subscriptions

| Subscription            | Expiry     | Price     |
|-------------------------|------------|-----------|
| [polll.org](polll.org)  | 11/24/2025 | $10/year  |
| admin@polll.org         | 02/23/2025 | $2/month  |

## Technology Stack

[Hatch](https://hatch.pypa.io/1.9/) for project management (i.e. publishing, versioning, etc.)

[Flask](https://flask.palletsprojects.com/en/stable/) (Python) for handling HTTP requests and reading/writing to the database:

- [Pytest](https://docs.pytest.org/en/stable/) and [Coverage](https://coverage.readthedocs.io/en/7.6.9/) for testing
- [Authlib](https://authlib.org/), [python-dotenv](https://pypi.org/project/python-dotenv/), and [requests](https://docs.python-requests.org/en/latest/index.html) for authentication with [Auth0](https://auth0.com/)

[SQLite3](https://docs.python.org/3/library/sqlite3.html) as a database. [Here](https://www.sqlitetutorial.net/) is a good introduction to this technology.

[HTMX](https://htmx.org/) for additional front-end functionality (more nuanced HTTP requests/responses)

[TailwindCSS](https://tailwindcss.com/) for front-end design

[Railway](https://railway.com/) for hosting the prototype, [Google Cloud](https://cloud.google.com/?hl=en) for hosting production

### Philosophy

Before adding a new technology, ask yourself the following three questions:

1. Is this new technology required to implement a feature?
2. If so, how painful would it be to build this feature with our current stack?
3. Does the pain of building this feature with our current stack outweight the complexity created by a new technology?

If the answer to all three of the questions is "yes", add the new technology to the stack.

## Project Layout

`/requirements.txt` contains dependencies (see [Setup Instructions](#setup-instructions)).

`/tests` should contains unit tests (TBD).

`/src/instance` and `/src/migrations` store database files and can be ignored.

`/src/app.py` launches the app (see [Setup Instructions](#setup-instructions)).

`/src/polll` contains the source code for the app:

- `/templates` contains the [Jinja2](https://jinja.palletsprojects.com/en/stable/) templates used to generate the app
- `/static` contains static files (i.e. images, the logo, etc.)
- `/results` contains database queries for getting poll results
- `auth.py` sets up the user authentication blueprint with Auth0
- `poll.py` implements the main HTTP routes used by users
- `admin.py` implements additional HTTP routes for the administrator
- `db.py` creates a database connection with the SQLite3 database
- `responses.py` updates the database when the user responds to a poll
- `results.py` queries the database to get results when the user views a poll

## Setup Instructions

In order to run the app locally, you will need a [Virtual Environment](https://docs.python.org/3/library/venv.html), which can be created using the `venv` library provided with the base installation of Python3. To create a new virtual environment from the `requirements.txt` file following these steps:

- Open a terminal and `cd` to the root directory of the project
- Run `python3 -m venv venv`. This will create a new virtual environment called `venv` within the root directory of the project.
- Run `source venv/bin/activate` to enter the virtual environment.
- Use `pip install -r requirements.txt` to install the packages listed in `requirements.txt` in the virtual environment.

To run the app, type `python3 src/app.py` into a terminal from the root directory.

If you are making changes to the HTML using TailwindCSS, you will also need to enable the Tailwind watcher. To do this, open another terminal window (separate from the one that is running the app), `cd` to `src/polll/static` and type in the following command:

```
./tailwindcss -i input.css -o output.css --watch
```

I made an effort to remove some of the unnecessary files (some of which were also a security risk) from the Github repository. Therefore, these instructions may not be 100% complete. Just let me know if you have an issue.

## Git

If you would like to contribute code to the project, you must have a working understanding of [git](https://git-scm.com/) and [GitHub](https://github.com/). _This is not negotiable_. To get a big picture idea of how `git` works, I recommend you read [this](https://missing.csail.mit.edu/2020/version-control/) guide. After doing this, you should be able to answer the following questions:

- What is a staging area? How do I `add` changes to a staging area?
- What is a remote? How do I add a remote to a repository?
- What does a `commit`/`push` do? Which one updates a remote?
- How do I get recent changes from a remote?
- How do I commit my changes to a branch and then create a pull request?

Please write clear commit messages in the present tense (i.e. "Update response UI" instead of "Updated response UI"). Additionally, try to make a commit every time you make a signfiicant change. I am happy to get involved with the trickier parts of `git` (i.e. merge conflicts), but you should be able to handle most stuff (i.e. pulling changes, committing to a branch, opening a pull request) on your own.

## Mail Setup

See the instructions [here](https://www.namecheap.com/support/knowledgebase/article.aspx/9188/2175/gmail-fetcher-setup-for-namecheap-private-email/) to link the company email to your personal gmail account. Our company email address is admin@polll.org. Please set your name to "Admin" to retain anonymity. When choosing a port to send from, use SSL on port 465. Contact me for the email account password and the development account password (these are not the same).
