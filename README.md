# poll-app

See [here](https://docs.google.com/document/d/1rV5vO5JzADLJp9fIChyTnYNT_mIAT9rMD2FZ7_xElhQ/edit?tab=t.0) for documentation.

## ignacio styling instructions 

1. The only folder you are allowed to change is `src/polll/templates`
2. `base.html` inherited by all of the HTML templates. you should not need to change this
3. Three "main" pages:
	1. `admin.html` (admin dashboard) 
	2. `index.html` (landing page)
	3. `home.html` (main page)
4. Do not touch HTML attributes that already exist. Do not touch anything in `{{` or `{%`
5. Feel free to add divs or to change HTML tags as long as shit doesn't break

Running the app (three easy steps):
1. Open a terminal. Type `source .venv/bin/activate`. Turn it off with `deactivate`
2. From the same terminal, type in `flask run --debug`
3. Open a *second* terminal. Type in `cd src/polll/static`. Type in `./tailwindcss -i input.css -o output.css --watch` and press enter. This will start the tailwind compiler.

Using in three easy steps:
1. Go to https://tailwindcss.com/docs/installation
2. Open quick search and type in what you want to do to the page
3. Pick an element and give it a `class` attribute
