# Development Checklist

## Riley

Code Quality (Commit #1)

- [ ] Improve code quality:
  - Reorganize blueprints (admin/home/poll/comment)
  - Centralize helpers in a single `utils.py` file
  - Create abstractions where possible (i.e. `like`/`dislike`)
- [ ] Test for security vulnerabilities (SQL injection, endpoint permissions)
- [ ] Test for bugs, do a full click through of the app

UI Improvements (Commit #2)

- [ ] Ability to pin polls from admin
- [ ] Sort top by day/week/month/year/all time
- [ ] Switch the pie/bar chart for choose one/many
- [ ] Enforce lowercase usernames without spaces and special characters

Admin Improvements (Commit #3)

- [ ] View polls in boards (admin) should redirect to polls
- [ ] Ensure that deleting a board fully deletes all polls
- [ ] Add ability to mute user (prevent from posting/commenting), ban user
- [ ] Add ability to view comments from poll UI and delete them
- [ ] Add other sort options to the poll section of the admin UI

## Matt

### Important

- [ ] Fix ranked alignment issue
- [ ] Perfect graph visuals
- [ ] Visually differentiate the 'choose one' and 'choose many' input fields

### Small/Secondary

- [ ] Adjust 'create-card' to fit the screen

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
