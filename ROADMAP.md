# Development Roadmap

- [Master Checklist](https://docs.google.com/spreadsheets/d/1_l05MRtndCjIhHvqixORiueiIIFqz9E6iD2b9xADoRE/edit?usp=sharing) (contains non-technical items as well)
- [Database Schema](https://drive.google.com/file/d/1miwHyiKxAsvqpu6lSzgJPm7c2lLgoC4g/view?usp=drive_link)

## UI Development Branch
- ### General:
  - [x] Design "templates/home/menu-footer.html" for small screens
  - [x] Hide "share/report/submit" text on small screens and scale button sizes appropriately
  - [x] Replace "My Polls" with the username
  - [ ] Replace radio/checkbox in the choose one/many interface with boxes[^2]
  - [ ] Add light-mode compatible logo
  - [ ] Make light-mode look better (possibly add a darker gray)
  - [ ] Make the admin UI look a little nicer (remove bright borders, etc)
- ### Nitpicks/Suggestions:
  - **Feed**:
    - [ ] Adjust the size/refactor the settings/theme button on small screens (currently very clunky)
    - [ ] Shrink the navbar/poll cards and make it transparent/gradient as opposed to covering the background
    - [ ] Experiment with one fluid stream of polls on mobile as opposed to the current disconnected card implementation (akin to the mobile versions of Instagram, Facebook, Reddit)
    - [ ] Add a confirmation message to the logout button
    - [ ] Give the buttons a shadow or something to make them look like they weren't just arbitrarily pasted on the screen
    - [ ] Add date/timestamps to poll cards
  - **Create Poll**:
    - [ ] Add a keyboard shortcut to create a new answer (ENTER) and create poll (SHIFT + ENTER)
    - [ ] Create a ui element that confirms a poll's creation instead of the current "alert()" message
    - [x] Turn off text suggestions for input fields
    - [ ] Swap the position of the "Add Answer" and "Create Poll" button and place "Add Answer" on the left side of the form
    - [ ] Consider a font/font-weight that cleanly and intuitively differentiates the input with the prompts as right now there is little visual difference between the text field and the buttons/instructions around them
    - [ ] Remove the delete button when there is only one option for "choose one/many/ranking"
    - [ ] Explore other options for a better looking input experience e.g. change the dropdown to something other than the browser/os default (maybe a small graphic accompanying the input options?)
    - [ ] Ensure breakpoints are in place, or perhaps consider an alternative mobile layout
    - [ ] The "Create Poll" button should feel more meaningful when clicked. Add a small clickable pop-up that confirms a poll has been created (small animation maybe?). When clicked it jumps to the poll in the feed.
    - [ ] Make the container box for the poll creation feel less like is is just arbitrary pasted onto a canvas i.e. make it along with the other elements on the page look like one cohesive unit

## Pull Requests (Frontend)

These are development items that I think someone other than me (Riley) could do. If you are going to take on one of these, please create a branch, and then submit a pull request when you are finished. Most of these tasks involve working with the UI and should involve little to no back-end development.

| Difficulty | Task                                                                   | Status      |
| ---------- | ---------------------------------------------------------------------- | ----------- |
| 3/10       | Ensure UI can handle unusually long questions and answers.             | Unclaimed   |
| 4/10       | Ensure compatibility with different screen sizes with CSS breakpoints. | In Progress |
| 4/10       | Add a countdown to the `/create` endpoint when a user creates a poll.  | Unclaimed   |
| 8/10[^3]   | Ensure the tier list properly handles many items. Improve UI.          | Unclaimed   |
| 6/10       | Add sorting functions on the feed/history/my polls tabs.               | In Progress |

## Pull Requests (Backend)

- [ ] Allow regular users to make themselves anonymous on polls
- [ ] Allow anonymous responses on polls
- [ ] Create poll boards
- [ ] Set a time limit (expiry date) on polls

| Difficulty | Task                                                                   | Status    |
| ---------- | ---------------------------------------------------------------------- | --------- |
| 7/10       | Add a nice abstraction to `responses.py` to reduce code duplication.   | Unclaimed |
| 7/10       | Add a nice abstraction to `results.py` to reduce code duplication.     | Unclaimed |
| 5/10       | Make the user's response appear in the results tab.                    | Unclaimed |
| 7/10       | Improve the API for getting results for tier list and ranking.         | Unclaimed |
| 6/10       | Implement empty responses (i.e. showing the answer without responding) | Unclaimed |

[^2]: In addition to an SVG file containing the new logo, this pull request may also implement switching between logos depending on the `localStorage.theme` variable. This variable is updated when the user toggles light/dark mode. In the appropriate template file, add an `id` to the logo element. Then in `dark-mode.js`, update the event listener so that on page load, the correct logo gets displayed. Additionally, you will need to update the `setLightMode()` and `setDarkMode()` functions so that the logo changes when somebody clicks the light/dark mode toggle.

[^3]: Requires a willingness to work with some fairly advanced CSS concepts (flexbox) and some tricky Javascript ([drag and drop](https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API)).

## 1: Minimum Viable App

- [ ] Custom Results Interface (show total # of votes)
  - [ ] Choose One (uniform colour + different colour on select)
  - [ ] Choose Many (same as choose one)
  - [ ] Numeric Scale
  - [ ] Numeric Star (TBD)
  - [ ] Ranked Poll
  - [ ] Tier List
- [ ] Interoperability Features
  - [x] Create a randomized URL for each poll that users can share.
  - [ ] Allow users to respond but require login to see results.
  - [ ] Anonymous responses saved to the database, linked to user after registration.
  - [ ] Allow anonymous responses on a poll-by-poll basis.
- [ ] Ability to set a time limit (expiry date) on polls
- [ ] Poll Boards

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
