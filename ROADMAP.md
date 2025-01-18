# Development Checklist

## Riley

- [ ] Email verification is not working
- [ ] Filter by board (in admin) not set up
- [ ] Linked poll UI should be different when logged in
- [ ] Add/improve light mode
- [ ] Address mobile/small screen sizes
- [ ] Configure light/dark mode for all new elements in dark-mode.js
- [ ] Make it impossible to unselect the 'All' board

## Matt

### Important

- Ensure graphs function correctly:
  - [x] Test the scale graph for different inputs (> 2 of the same votes; likely a javascript issue)
  - [x] Standardize the bandwidth parameter (0.25 works pretty well)
  - [x] Fix the average algorithm
  - [x] Add user response to graphs and ensure it works both when the user is the author and a voter
  - [ ] Address the race condition of when a user votes and their response is not plotted because the page
        loads before the database has had time to update
- Style the graphs and implement breakpoints
  - [ ] Make each graph as aesthetically/interactively pleasing as possible
  - [ ] Annotate 'choose one' and 'choose many' with the user's response
  - [ ] Brainstorm tier lists annotation
  - [ ] Add breakpoints and ensure there is a pleasing mobile experience

### Small/Secondary

- [ ] Make sure poll results display properly with no responses
- [ ] Restyle hot/top/new buttons
- [ ] Round percentages on choose one/choose many
- [ ] Add a message/graphic to an empty feed
- [ ] Find a way to differentiate between choose one and choose many

# Roadmap

- [ ] Add image upload support for creating tier lists as well as displaying then in feed/results (can put images on graph no problem).
- [ ] If adopting a poll type with exactly two answers e.g. poltical compass, use a scatter plot/heatmap representing frequency in 2D (might need 2D KDE)

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
