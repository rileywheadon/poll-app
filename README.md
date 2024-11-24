# poll-app

## Overview

Virtual Environment:
- Create:  `python3 -m venv venv`
- Load: `source venv/bin/activate`

Flask (`flask`):
- Run: `flask run --debug --port=5000`

## Flask

- `render_template()` renders a Jinja2 template given parameters
- `redirect()`is used to hit another HTTP endpoint on command
- `url_for()` automatically fuzzy finds the URL for a given endpoint
- [HTTP Requests](https://stackoverflow.com/questions/10434599/get-the-data-received-in-a-flask-request)

## SQLAlchemy

The `db.session` object is used to execute queries and modify model data.
- `db.session.add(obj)` stages an object for insertion
- `db.session.delete(obj)` stages an object for deletion
- Changing attributes on `obj` stages modifications
- `db.session.commit()` commits any of the above operations

`db.session.execute(...)` queries the database and returns a `Result` object.
- `Result.scalars()` returns a `ScalarResult` filtering object
- `ScalarResult.all()` returns all scalar values in a sequence
- `Result.scalar()` returns returns the first object in `Result`

Scalar objects can be passed to `render_template()` as regular Python objects.

### Defining Models

- Use `so.Mapped[]` class to set the type of each attribute.
- Use `sa.ForeignKey()` to specify that an attribute is a key of another table.
- Use `so.relationship()` to define a relationship between attributes in different tables.

### Modifying the Database from the Terminal

- Ensure you are in the app context using `app.app_context().push()` 
- Create an object defined in the data model and assign it to a variable
- Then use `db.session.add(...)` and `db.session.commit()`

## Login System

- https://codeshack.io/login-system-python-flask-mysql/
- https://flask-login.readthedocs.io/en/latest/#configuring-your-application

## Folder Setup

- `templates/`: Contains Jinja2 HTML templates
- `app.py`: Code for generating the app, initializing the database, etc.
- `models.py`: Definitions of data models for SQLAlchemy
- `routes.py`: Definitions of HTTP routes the application can hit
