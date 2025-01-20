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
- [ ] Implement tier list side by side results
- [ ] Make each graph as aesthetically/interactively pleasing as possible
- [ ] Add breakpoints and ensure there is a pleasing mobile experience

### Small/Secondary

- [ ] Visually differentiate the 'choose one' and 'choose many' input fields
- [ ] Restyle right sidebar
- [ ] Remove datalabel on the bar graph if the option has no votes
- [ ] Change create confirmation message from the current js alert to something better
- [ ] Be editing the text field automatically when having just added a new option in the 'create' tab
- [ ] Fix filter labeling on page refresh and make the dropdown dissapear when clicking anywhere
- [ ] Grey pie chart options on the side with no votes
- [ ] Remove report and sharing popping out feature

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
