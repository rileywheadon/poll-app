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

- [x] Ensure graphs function:
  - Test the scale graph for different inputs (> 2 of the same votes; likely a javascript issue)
  - Standardize the bandwidth parameter
- [ ] Fix average algorithm
- [ ] Style the graphs and implement breakpoints
- [ ] Update all result templates to show your response (if it exists)

### Small/Secondary

- [ ] Make sure poll results display properly with no responses
- [ ] Restyle hot/top/new buttons
- [ ] Round percentages on choose one/choose many
- [ ] Make sure that KDE works with 0/1 responses
- [ ] Additional issue with the KDE at 4 responses (or on duplicate responses?)
- [ ] Add a message/graphic to an empty feed

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
