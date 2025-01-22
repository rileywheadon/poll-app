# Development Checklist

## Riley

- [ ] Add ability to mute user (prevent from posting/commenting), ban user
- [ ] Light mode compatibility

## Matt

### Important

- [ ] Fix ranked alignment
- [ ] Perfect graph visuals
- [ ] Add breakpoints

### Small/Secondary

- [x] Hide comments/show polls text on mobile
- [x] Fix tier list box inheritence when dragging
- [ ] Adjust 'create-card' to fit the screen/change to horizontal layout above/below the create space

# Roadmap

- [ ] Implement captcha on form submit
- [ ] Load up to 20 polls at a time before having to click "load more"
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
