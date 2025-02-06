# Development Checklist

## Riley

### Merge

Frontend Changes:

- Change enter event listener in `/create`
- Left menu is not mobile compatible
- Scale endpoints getting cut off
- Smooth transition when "show graph" is clicked

### Production

Step 1: Set up Heroku

- Sign up for a Heroku basic account (\$7/month)
- Install the Heroku CLI and set up the app
- Launch and put the app on rwheadon.dev
- This is a **Staging Environment**

Step 2: Go through the production checklist on Supabase

- Buy a pro account (\$25/month)
- Set up the supabase CLI
- Add RLS
- Add SMTP
- Add SSL enforcement
- Enable network restrictions
- Set the expiry on OTPs
- Create a branch for development and a branch for production
- Get the app onto polll.org, the **Production Environment**

## Matt

- [ ] Tier list results toggle between user and average response
- [ ] Fix Tier list breakpoint issues
- [ ] Add a loading bar to show graphs/comments

# Roadmap

- [ ] Implement captcha on form submit
- [ ] Add image upload support for creating tier lists as well as displaying then in feed/results (can put images on graph no problem).
- [ ] If adopting a poll type with exactly two answers e.g. poltical compass, use a scatter plot/heatmap representing frequency in 2D (might need 2D KDE)

# Notes

If login is too slow, note that we are currently:

- Querying user likes/dislikes on login
- Querying boards on login
