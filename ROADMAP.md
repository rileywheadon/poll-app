# Development Checklist

## Riley

### Merge

Frontend Changes:

- Change enter event listener in `/create`
- Left menu is not mobile compatible
- Scale endpoints getting cut off

### Production

- Integrate the supabase CLI with github and create a branch
- https://makerkit.dev/docs/next-supabase-turbo/going-to-production/supabase
- https://flask.palletsprojects.com/en/stable/deploying/

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
