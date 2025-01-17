# Development Checklist

## Bug Fixes

- [ ] Email verification is not working
- [ ] Filter by board (in admin ) not set up
- [ ] Linked poll UI should be different when logged in

## UI Development

### Important

- [ ] Improve the look of all graphs
- [ ] Update all result templates to show your response (if it exists)
- [ ] Address mobile/small screen sizes
- [ ] Add/improve light mode
- [ ] Configure light/dark mode for all new elements in dark-mode.js
- [ ] Add image upload support for creating tier lists as well as displaying then in feed/results (can put images on graph no problem)

### Small/Secondary

- [ ] Make sure poll results display properly with no responses
- [ ] Round percentages on choose one/choose many
- [ ] Make sure that KDE works with 0/1 responses
- [ ] Additional issue with the KDE during duplicate responses
- [ ] If adopting a poll type with exactly two answers e.g. poltical compass, use a scatter plot/heatmap representing frequency in 2D (might need 2D KDE)

# Roadmap

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
