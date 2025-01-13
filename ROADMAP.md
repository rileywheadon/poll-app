# Development Checklists

## UI

General:

## UI Development Branch

- ### General:
  - [x] Design "templates/home/menu-footer.html" for small screens
  - [x] Hide "share/report/submit" text on small screens and scale button sizes appropriately
  - [x] Replace "My Polls" with the username
  - [x] Add light-mode compatible logo
  - [x] Replace radio/checkbox in the choose one/many interface with boxes[^2]
  - [ ] Make light-mode look better (possibly add a darker gray)
  - [ ] Make the admin UI look a little nicer (remove bright borders, etc)
- ### Nitpicks/Suggestions:
  - **Feed**:
    - [x] Adjust the size/refactor the settings/theme button on small screens (currently very clunky)
    - [x] Shrink the navbar/poll cards and make it transparent/gradient as opposed to covering the background
    - [x] Experiment with one fluid stream of polls on mobile as opposed to the current disconnected card implementation (akin to the mobile versions of Instagram, Facebook, Reddit)
    - [x] https://flowbite.com/docs/plugins/charts for charts native to tailwind (Needs ApexChart install or cdn) (using chartjs)
    - [x] Add a confirmation message to the logout button
    - [x] Give the buttons a shadow or something to make them look like they weren't just arbitrarily pasted on the screen
    - [x] Add date/timestamps to poll cards
    - [ ] Use a heatmap if results are ever a function of two variables (2D KDE needed)
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
    - [x] The "Create Poll" button should feel more meaningful when clicked. Add a small clickable pop-up that confirms a poll has been created (small animation maybe?). When clicked it jumps to the poll in the feed.
    - [x] Make the container box for the poll creation feel less like is is just arbitrary pasted onto a canvas i.e. make it along with the other elements on the page look like one cohesive unit
    - [ ] Allow users to drag and drop images for the tier list mode (HARD?)

Known bugs:

- [x] Scroll is broken in admin (FIXED)
- [ ] Multiple star selectors don't work

## Backend

NEXT PR:

- [ ] Add sorting function on feed/history/my polls
- [ ] Create poll boards
- [ ] Improve the API for getting results for tier list and ranking
- [ ] Rewrite `responses.py` and `results.py`
- [ ] Make the user's response appear in the results tab
- Finish interoperability
  - [x] Create a randomized URL for each poll that users can share.
  - [ ] Allow users to respond but require login to see results.
  - [ ] Anonymous responses saved to the database, linked to user after registration.
  - [ ] Allow anonymous responses on a poll-by-poll basis.

# Feature Roadmap

## 1: Minimum Viable App

- [ ] Custom Results Interface (show total # of votes)
  - [ ] Choose One (uniform colour + different colour on select)
  - [ ] Choose Many (same as choose one)
  - [ ] Numeric Scale
  - [ ] Numeric Star (TBD)
  - [ ] Ranked Poll
  - [ ] Tier List

## 2: Staging

- [ ] Push the app to Railway. Allow trusted people to test.
- [ ] Write unit tests.
- [ ] Test for security vulnerabilities (SQL injection, endpoint permissions)

## 3: Launch

- [ ] Deploy to Google Cloud Services
- [ ] Create a dashboard to manage application health and uptime
- [ ] Set up automatic alerts when errors occur on production

## 4: Minimum Viable product

- [AI-Powered Poll Tagging](https://docs.google.com/document/d/1knJN9BY2EJ27TZhUlEIYxNZZmU6g-eYaLxmL75ShN_U/edit?usp=drive_link)
- Poll Dashboard
- Payment Processing
