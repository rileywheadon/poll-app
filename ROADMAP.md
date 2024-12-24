# Development Roadmap

- [Master Checklist](https://docs.google.com/spreadsheets/d/1_l05MRtndCjIhHvqixORiueiIIFqz9E6iD2b9xADoRE/edit?usp=sharing) (contains non-technical items as well)
- [Database Schema](https://drive.google.com/file/d/1miwHyiKxAsvqpu6lSzgJPm7c2lLgoC4g/view?usp=drive_link)

## Pull Requests

These are development items that I think someone other than me (Riley) could do. If you are going to take on one of these, please create a branch, and then submit a pull request when you are finished.

| ID  | Difficulty | Task                                                     |
| --- | ---------- | -------------------------------------------------------- |
| 1   |            | Assorted UI improvements (i.e. hover effects)            |
| 2   |            | Test UI with unusually long questions/answers. Hover?    |
| 3   | 4/10       | Make tier list expand when line is full.                 |
| 4   | 2/10       | Replace the choose one/many interface with boxes. Hover? |
| 5   | 3/10       | Add light-mode compatible logo.                          |
| 6   | 3/10       | Improving the Poll UI.                                   |
| 7   | 4/10       | Test compatibility with different screen sizes.          |
| 8   | 7/10       | Prototype in-house results visualization.                |

**5**: In addition to an SVG file containing the new logo, this pull request may also implement switching between logos depending on the `localStorage.theme` variable. This variable is updated when the user toggles light/dark mode. In the appropriate template file, add an `id` to the logo element. Then in `dark-mode.js`, update the event listener so that on page load, the correct logo gets displayed. Additionally, you will need to update the `setLightMode()` and `setDarkMode()` functions so that the logo changes when somebody clicks the light/dark mode toggle.

**6**: In particular we need to add a "share" link (use the FontAwesome icons) and a "created by" line in the bottom right corner of every poll. You do not have to actually implement these features, just write the HTML and style it.

**7**: This is trickier than it sounds. You need to ensure the app works properly on screens of all different sizes. Check the Tailwind docs for instructions on how to implement CSS breakpoints, which you will need to learn.

**8**: Start with the simplest poll (choose one). You will have to create a new Jinja2 template that displays the results for choose one. Instead of making calls to plotly from Python, send the data to the client and use Javascript to render a homemade bar chart. I would prefer if we avoided Javascript plotting libraries and did everything by hand, as I think this would be the most flexible implementation. However, I am open to other ideas. If you are interested in attempting this, please let me know and I will give you more information.

## 1: Minimum Viable App

### Setup

- [x] Add Flask/Tailwind
- [x] Add SQLAlchemy
- [x] Create Landing Page
- [x] Develop Database Schema

### User Authentication

- [x] Login
- [x] Register
- [x] Protected HTTP Endpoints

### Visualizing Results

- [x] Choose One
- [x] Choose Many
- [x] Numeric Star
- [x] Numeric Scale
- [x] Ranked Poll
- [x] Tier List

### Poll Boards

- [ ] Add Boards to Schema
- [ ] Include boards in the /admin UI
- [ ] Filter by board on the left sidebar

### Administrator

- [x] Create admin@polll.org email address
- [ ] The administrator should have the following privileges:
  - Respond multiple times to the same poll
  - Edit/Delete any poll on the website
  - Remove people's responses
  - View results for all polls
  - Query users/polls/responses/etc.

### Poll Creation

- [ ] Build the /create endpoint
- [ ] Allow users to create one poll per day. Display a timer.
- [ ] Add a “My Polls” section to the /create endpoint
- [ ] Allow users to see responses to their own polls
- [ ] Allow users to delete their own polls
- [ ] Prevent users from responding to their own polls

### Viewing Submitted Polls

- [ ] “History” tab that allows users to see results from polls they’ve responded to.
- [ ] Sort by newest response, oldest response, poll popularity

### Interoperability

- [ ] Create a randomized URL for each poll that users can share.
- [ ] This URL links to a one-off poll which has the following features:
- [ ] Users can respond anonymously
- [ ] Users can see results anonymously
- [ ] After responding, the app recommends other polls
- [ ] To access these polls, anonymous users must register/login
- [ ] Test sharing these links on social media websites

### Custom Results Interface

- [ ] Generate charts using raw HTML/JS using server-side data
  - Customize for each poll type
  - Iterate on the design, build once
  - This will be tedious and time consuming
  - Remove bloat (i.e. numpy, plotly) afterwards

### Styling and Cross-Device Support

- [x] Switch to the Nord colour palette
- [x] Add light/dark mode toggle
- [ ] Encode logo in SVG/HTML
- [ ] Ensure pages are responsive to changes in window size
- [x] Ensure there are no scroll overflow bugs

## 2: Launch

### Staging Environment

- [ ] Push the app to Railway. Allow TRUSTED people to test
- Write unit tests
- Refine the UI/UX
- Fix bugs as they appear

### Production and Launch

- [ ] Deploy to Google Cloud Services
- [ ] Create a dashboard to manage application health and uptime
- [ ] Set up automatic alerts when errors occur on production

## 3: Minimum Viable App

- [AI-Powered Poll Tagging](https://docs.google.com/document/d/1knJN9BY2EJ27TZhUlEIYxNZZmU6g-eYaLxmL75ShN_U/edit?usp=drive_link)
- Poll Dashboard
- Payment Processing
