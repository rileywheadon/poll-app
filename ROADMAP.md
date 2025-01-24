# Development Checklist

## Riley

Admin Changes

- [ ] View polls in boards (admin) should redirect to polls
- [ ] Add ability to mute user (prevent from posting/commenting), ban user
- [ ] Add ability to view comments from poll UI and delete them
- [ ] Add other sort options to the poll section of the admin UI
- [ ] Ability to pin polls from admin

Other Changes

- [ ] Sort top by day/week/month/year/all time
- [ ] Poll sorting in history/mypolls
- [ ] Enforce lowercase usernames without spaces and special characters
- [ ] Add custom endpoints to the scale
- [ ] Ranked poll needs two-click interface

Testing

- [ ] Test for security vulnerabilities (SQL injection, endpoint permissions)
- [ ] Test for bugs, do a full click through of the app

## Matt

### Important

- [x] Fix ranked element size issue (min width on grid?)
- [x] Switch the pie/bar chart for choose one/many
- [x] Add a hint that green is for user results and blue is for average
- [ ] Visually differentiate the 'choose one' and 'choose many' input fields
- [ ] Perfect graph visuals

### Small/Secondary

- [ ] Adjust 'create-card' to fit the screen
- [ ] Change "all" board to general
- [ ] Change the board colour scheme (in create, to poll green/blue)
- [ ] Add a nice icon (an eye, maybe?) to the anonymous checkbox
- [ ] Light up tier list sections on hover
- [ ] Widen the ranking boxes in results so they all have the same size
- [ ] In ranking, make the "you" boxes green and the "average" boxes blue
- [ ] Set default colour scheme to dark mode (just add the "dark" class to body I think)

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
