# Development Checklists

## UI

General:

## UI Development Branch

- ### General:
  - [x] Design "templates/home/menu-footer.html" for small screens
  - [x] Hide "share/report/submit" text on small screens and scale button sizes appropriately
  - [x] Replace "My Polls" with the username
  - [x] Add light-mode compatible logo
  - [ ] Replace radio/checkbox in the choose one/many interface with boxes[^2]
  - [ ] Make light-mode look better (possibly add a darker gray)
  - [ ] Make the admin UI look a little nicer (remove bright borders, etc)
- ### Nitpicks/Suggestions:
  - **Feed**:
    - [ ] Adjust the size/refactor the settings/theme button on small screens (currently very clunky)
    - [ ] Shrink the navbar/poll cards and make it transparent/gradient as opposed to covering the background
    - [ ] Experiment with one fluid stream of polls on mobile as opposed to the current disconnected card implementation (akin to the mobile versions of Instagram, Facebook, Reddit)
    - [ ] https://flowbite.com/docs/plugins/charts for charts native to tailwind (Needs ApexChart install or cdn)
    - [ ] Add a confirmation message to the logout button
    - [ ] Give the buttons a shadow or something to make them look like they weren't just arbitrarily pasted on the screen
    - [ ] Add date/timestamps to poll cards
  - **Create Poll**:
    - [ ] Add a keyboard shortcut to create a new answer (ENTER) and create poll (SHIFT + ENTER)
    - [ ] Create a ui element that confirms a poll's creation instead of the current "alert()" message
    - [x] Turn off text suggestions for input fields
    - [x] Swap the position of the "Add Answer" and "Create Poll" button and place "Add Answer" on the left side of the form
    - [x] Consider a font/font-weight that cleanly and intuitively differentiates the input with the prompts as right now there is little visual difference between the text field and the buttons/instructions around them
    - [x] Remove the delete button when there is less than 2 options for "choose one/many/ranking"
    - [x] Explore other options for a better looking input experience
      - Change the dropdown to something other than the browser/os default (maybe a small graphic accompanying the input options?)
      - Explore tailwind templates (dropdowns, buttons, etc.)
      - Display medium images (maybe a graph or a preview of what the input would look like) as options instead of a dropdown as currently the "Create" tab is quite empty
    - [ ] Ensure breakpoints are in place, or perhaps consider an alternative mobile layout
    - [ ] The "Create Poll" button should feel more meaningful when clicked. Add a small clickable pop-up that confirms a poll has been created (small animation maybe?). When clicked it jumps to the poll in the feed.
    - [ ] Make the container box for the poll creation feel less like is is just arbitrary pasted onto a canvas i.e. make it along with the other elements on the page look like one cohesive unit
    - [ ] Allow users to drag and drop images for the tier list mode (HARD?)

## Backend

NEXT PR:

- [x] Add sorting function on feed/history/my polls
- [x] Create poll boards
- [x] Better form validation on 'Create'
- [x] Finish interoperability

---

- [ ] Improve the API for getting results for tier list and ranking
- [ ] Rewrite `responses.py` and `results.py`
- [ ] Make the user's response appear in the results tab

Data structure for poll:

- Regular fields (see `schema.sql`)
- `creator`: Username of the creator of the poll
- `votes`: Number of votes
- `answers`: List of answer/result objects (TODO)
- `repsonse`: Response object (TODO)
- `age`: Age string in days/hours/minutes/seconds

These should be computed in place:

- `url`: Anonymous response URL
- `poll_template`: Template for rendering the poll (by type)
- `result_template`: Template for rendering the result (by type)

Answer Objects (and results):

- Choose One: Number of resonses to each answer
- Choose Many: Number of resonses to each answer
- Numeric Star: Number of responses to each number (0-100)
- Ranked: Ordered list of answers (by average rank)
- Tier List: List of dictionaries `[item : {tier : count}]`

Response Objects:

- Choose One: A single answer object
- Choose Many: A list of answer objects
- Numeric Star: A single number (0-100)
- Ranked: Ordered list of answers (given from the users)
- Tier List: List of answers objects with the tier added

---

- [ ] No email verification (strange)

# Feature Roadmap

## 1: Staging

- [ ] Push the app to Railway. Allow trusted people to test.
- [ ] Write unit tests.
- [ ] Test for security vulnerabilities (SQL injection, endpoint permissions)

## 2: Launch

- [ ] Deploy to Google Cloud Services
- [ ] Create a dashboard to manage application health and uptime
- [ ] Set up automatic alerts when errors occur on production

## 3: Minimum Viable product

- [AI-Powered Poll Tagging](https://docs.google.com/document/d/1knJN9BY2EJ27TZhUlEIYxNZZmU6g-eYaLxmL75ShN_U/edit?usp=drive_link)
- Poll Dashboard
- Payment Processing
