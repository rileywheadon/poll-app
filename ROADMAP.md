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
- [ ] Fixed ranked results alignment
- [ ] Restyle right sidebar
- [ ] Make each graph as aesthetically/interactively pleasing as possible
- [ ] Visually differentiate the 'choose one' and 'choose many' input fields

### Small/Secondary
- [ ] Adjust 'create' image sizes to fit the screen
- [ ] Change 'create'/'report' confirmation messages from the curent js alert
- [ ] Fix the left sidebar's alignment
- [ ] Implement colour graident function with appropriate colours

# Roadmap

- [ ] Add image upload support for creating tier lists as well as displaying them in feed/results (can put images on graphs no problem).
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
