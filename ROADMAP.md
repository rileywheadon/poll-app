# Development Checklists

## UI

General:

## UI Development Branch

- ### Important:
  - [ ] Improve the look of the graphs
  - [ ] Address mobile/small screen sizes
  - [ ] Add/Improve light mode
  - [ ] Configure light/dark mode for all new elements in dark-mode.js
  - [ ] Add image upload support for creating tier lists as well as displaying then in feed/results (can put images on graph no problem)
- ### Small/Secondary:
  - [ ] Replace padding on left sidebar with something else to seperate items as it's messing with the footer on mobile screens
  - [ ] If adopting a poll type with exactly two answers e.g. poltical compass, use a scatter plot/heatmap representing frequency in 2D (might need 2D KDE)
  - [ ] Choose a cleaner time format for the daily poll reminder

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
