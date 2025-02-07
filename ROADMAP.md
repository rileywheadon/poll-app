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

- Clone the supabase project so we have a development and production database
- Set up Redis on production
- Configure the `polll.org` URL

Step 2: Go through the production checklist on Supabase

- Add SMTP
- Add SSL enforcement
- Enable network restrictions
- Set the expiry on OTPs

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
