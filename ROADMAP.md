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

- Change tier list drag and drop to a clickable interface
  - [ ] fix bug where when answers are selected inside of the tier list, 
        they are not unchecked when placed on some other tier (not breaking but annoying)
  - [ ] Correctly wire tier list results to the backend (breaking and annoying)
- [ ] Restructure ranked input so that it supports a clickable interface
- [ ] Implement clickable ranked input interface
- [ ] Perfect graph visuals

### Small/Secondary
- [ ] WHERE THE FUCK DID THE FOOTER GO ON CREATE MOBILE!!!!!!!!!!!!?!?!??!
    

# Roadmap

- [ ] Implement captcha on form submit
- [ ] Load up to 20 polls at a time before having to click "load more"
- [ ] Add image upload support for creating tier lists as well as displaying then in feed/results (can put images on graph no problem).
- [ ] If adopting a poll type with exactly two answers e.g. poltical compass, use a scatter plot/heatmap representing frequency in 2D (might need 2D KDE)
- [ ] Allow users to set custom upper and lower bounds on scale polls

## Launch

- [ ] Deploy to Google Cloud Services
- [ ] Create a dashboard to manage application health and uptime
- [ ] Set up automatic alerts when errors occur on production

## Minimum Viable product

- [AI-Powered Poll Tagging](https://docs.google.com/document/d/1knJN9BY2EJ27TZhUlEIYxNZZmU6g-eYaLxmL75ShN_U/edit?usp=drive_link)
- Poll Dashboard
- Payment Processing
