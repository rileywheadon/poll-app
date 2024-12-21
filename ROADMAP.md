# Development Roadmap

**Useful Links**:

- [Master Checklist](https://docs.google.com/spreadsheets/d/1_l05MRtndCjIhHvqixORiueiIIFqz9E6iD2b9xADoRE/edit?usp=sharing) (contains non-technical items as well)
- [Database Schema](https://drive.google.com/file/d/1miwHyiKxAsvqpu6lSzgJPm7c2lLgoC4g/view?usp=drive_link)

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

- [ ] Create admin@polll.org email address
- [ ] The administrator should have the following privileges:
- [ ] Respond multiple times to the same poll
- [ ] Edit/Delete any poll on the website
- [ ] View results for all polls
- [ ] Sort polls

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
- [ ] Customize for each poll type
- [ ] Iterate on the design, build once
- [ ] This will be tedious and time consuming

### Styling and Cross-Device Support

- [ ] Switch to the Nord colour palette
- [ ] Add light/dark mode toggle
- [ ] Encode logo in SVG/HTML
- [ ] Ensure pages are responsive to changes in window size
- [ ] Ensure there are no scroll overflow bugs
- [ ] Phase 2: Minimum Viable Product

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
