# Development Checklist

## Riley

- [ ] Poll sorting in history/mypolls
- [ ] Add custom endpoints to the scale
- [ ] View polls in boards (admin) should redirect to polls
- [ ] Add ability to mute user (prevent from posting/commenting)
- [ ] Add ability to ban user (prevent from logging in)
- [ ] Add ability to view comments from poll UI and delete them
- [ ] Add other sort options to the poll section of the admin UI
- [ ] Add ability to delete comments that you created
- [ ] Enforce lowercase usernames without spaces and special characters

---

- [ ] Test for security vulnerabilities (SQL injection, endpoint permissions)
- [ ] Test for bugs, do a full click through of the app

## Matt

### Important

- [ ] Change ranked into a clickable interface
- Add custom endpoints to scale:
  - [ ] Add in create as an input option
  - [ ] Add to input slider
  - [ ] Add to line graph

### Small/Secondary

- [ ] Change "all" board to general (need to change redirect from login page from 'All' to 'General')
- [ ] Short message in history and account when they're empty

# Roadmap

- [ ] Implement captcha on form submit
- [ ] Load up to 20 polls at a time before having to click "load more"
- [ ] Add image upload support for creating tier lists as well as displaying then in feed/results (can put images on graph no problem).
- [ ] If adopting a poll type with exactly two answers e.g. poltical compass, use a scatter plot/heatmap representing frequency in 2D (might need 2D KDE)

## Launch

- [ ] Deploy to Google Cloud Services
- [ ] Create a dashboard to manage application health and uptime
- [ ] Set up automatic alerts when errors occur on production

## Minimum Viable product

- [AI-Powered Poll Tagging](https://docs.google.com/document/d/1knJN9BY2EJ27TZhUlEIYxNZZmU6g-eYaLxmL75ShN_U/edit?usp=drive_link)
- Poll Dashboard
- Payment Processing
