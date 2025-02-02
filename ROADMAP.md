# Development Checklist

## Riley

### Rewrite

- Add ability to delete your own comments from poll UI

Admin:

- Just has to list comment reports (show text), poll reports (show question & answer), and boards
- Add the ability to mark a report as handled so it goes to the bottom of the list
- From the reports, add the option to ban (prevent from logging in) / mute (prevent from posting/commenting) the user
- Ability to set a primary board (which all polls are placed in automatically)

Comments:

- Currently querying user likes/dislikes with all comments. This is not scalable.

Results/Responses:

- Add custom endpoints to the scale

Security:

- Need to add row level security in a few places (see WARN comments)
- Need to add row level security to prevent duplicate poll submission (see WARN comments)
- Need to add row level security to prevent deleting other people's comments (see WARN comments)

Testing:

- Need to make sure poll pinning/closing works properly with multiple users
- Implement "Load More" button on feed
- Need to test out the feed using synthetic data

## Matt

### Important

- [ ] Ranked poll needs two-click interface
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
