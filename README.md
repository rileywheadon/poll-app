# polll

## Paid Subscriptions

| Subscription           | Renews     | Price     |
| ---------------------- | ---------- | --------- |
| [polll.org](polll.org) | 11/24/2025 | \$10/year |
| Heroku (Dyno)          | Monthly    | \$7/month |
| Heroku (Redis)         | Monthly    | \$3/month |

## Technology Stack

[Flask](https://flask.palletsprojects.com/en/stable/) (Python) as an application framework.

[Flask-Session](https://flask-session.readthedocs.io/en/latest/) and [Redis](https://redis.io/) for Server-Side sessions.

[Supabase](https://supabase.com/) for all things backend and user authentication.

[HTMX](https://htmx.org/) for additional front-end functionality (more nuanced HTTP requests/responses).

[TailwindCSS](https://tailwindcss.com/) as a CSS framework.

[Heroku](https://www.heroku.com/) as an application platform.

[gunicorn](https://gunicorn.org/) as a production web server.

[Cloudflare](https://www.cloudflare.com/) for DNS management and security.

[Resend](https://resend.com/) as an SMTP provider (sending verification emails to users).

### Philosophy

Before adding a new technology, ask yourself the following three questions:

1. Is this new technology required to implement a feature?
2. If so, how painful would it be to build this feature with our current stack?
3. Does the pain of building this feature with our current stack outweight the complexity created by a new technology?

If the answer to all three of the questions is "yes", add the new technology to the stack.

## Project Layout

`/requirements.txt` contains dependencies (see [Setup Instructions](#setup-instructions)).

`/src/app.py` launches the app (see [Setup Instructions](#setup-instructions)).

`/src/polll` contains the source code for the app:

- `__init__.py` contains the application factory that is responsible for creating the app
- `/templates` contains [Jinja2](https://jinja.palletsprojects.com/en/stable/) templates
- `/static` contains static files (i.e. images, the logo, scripts, stylesheets)
- `/results` contains database queries for getting poll results
- `/queries` contains a list of SQL queries used by Supabase (NOTE: these are just for reference)
- `auth.py`, `poll.py`, `home.py`, `comment.py`, `admin.py` contain HTTP endpoints
- `db.py` creates a database connection with Supabase
- `responses.py` updates the database when the user responds to a poll
- `results.py` queries the database to get results when the user views a poll
- `utils.py` contain various helper functions

## Setup Instructions

In order to run the app locally, you will need a [Virtual Environment](https://docs.python.org/3/library/venv.html), which can be created using the `venv` library provided with the base installation of Python3. To create a new virtual environment follow these steps:

- Open a terminal and `cd` to the root directory of the project.
- Run `python3 -m venv .venv` from the root directory.
- Run `source .venv/bin/activate` to enter the virtual environment.
- Use `pip install -r requirements.txt` to install the packages listed in `requirements.txt`.

**Note:** In order to better simulate a production environment, we are now running both the development _and_ production versions of the app using Heroku and gunicorn. In order to run the app, you will need to install [Heroku CLI](https://devcenter.heroku.com/categories/command-line). To double check that installation was successful, make sure that the command `heroku --version` does not return an error. Then, use `heroku local` to run the app from the root directory.

**TailwindCSS**: If you are making changes to the UI using TailwindCSS, you will also need to activate a Tailwind CSS watcher. To do this, open another terminal window (separate from the one that is running the app), `cd` to `src/polll/static` and type in the following command:

```
./tailwindcss-macos -i input.css -o output.css --watch
```

**Redis**: The app now uses server-side sessions. To simulate a server-side session in a development environment, you will have to install the [Redis](https://redis.io/) CLI and run a redis server using the `redis-server` command in _another_ terminal.

**Files**: For security reasons, certain sensitive files cannot be stored in the Github repository. In particular, you will require the `cert.pem`, `key.pem`, and `.env` files. Please contact me so I can provide you with these files.

## Git

If you would like to contribute code to the project, you must have a working understanding of [git](https://git-scm.com/) and [GitHub](https://github.com/). _This is not negotiable_. To get a big picture idea of how `git` works, I recommend you read [this](https://missing.csail.mit.edu/2020/version-control/) guide. After doing this, you should be able to answer the following questions:

- What is a staging area? How do I `add` changes to a staging area?
- What is a remote? How do I add a remote to a repository?
- What does a `commit`/`push` do? Which one updates a remote?
- How do I get recent changes from a remote?
- How do I commit my changes to a branch and then create a pull request?

Please write clear commit messages in the present tense (i.e. "Update response UI" instead of "Updated response UI"). Additionally, try to make a commit every time you make a signfiicant change. I am happy to get involved with the trickier parts of `git` (i.e. merge conflicts), but you should be able to handle most stuff (i.e. pulling changes, committing to a branch, opening a pull request) on your own.
