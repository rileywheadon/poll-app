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

- [ ] Ranked poll needs two-click interface
- [ ] Visually differentiate the 'choose one' and 'choose many' input fields
- [ ] Perfect graph visuals

### Small/Secondary

- [x] Adjust 'create-card' to fit the screen
- [x] Change the board colour scheme in create to polll blue/green (Not sure what this meant but I did my best)
- [x] Light up tier list sections on hover (I don't like it)
- [ ] Change "all" board to general (need to change redirect from login page from 'All' to 'General')
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
