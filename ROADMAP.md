# Development Checklist

If login is too slow, note that we are currently:

- Querying user likes/dislikes on login
- Querying boards on login

## Riley

### After Merge

- Add custom endpoints to the scale
- Light mode

### Production

- Integrate the supabase CLI with github and create a branch
- https://makerkit.dev/docs/next-supabase-turbo/going-to-production/supabase
- https://flask.palletsprojects.com/en/stable/deploying/

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
