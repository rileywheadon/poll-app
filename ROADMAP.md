# Development Checklist

## Riley

### Merge

Backend Changes:

- Custom scale endpoints

Frontend Changes:

- Change enter event listener in `/create`
- Rewrite some of the soup in `ui.js` and `graphs.js`

### Production

- Integrate the supabase CLI with github and create a branch
- https://makerkit.dev/docs/next-supabase-turbo/going-to-production/supabase
- https://flask.palletsprojects.com/en/stable/deploying/

## Matt


- ### Important:

- [ ] Tier list results toggle between user and average response
- [ ] Fix Tier list breakpoint issues
- [ ] Add a loading bar to show graphs/comments
- [ ] Improve the look and feel of **everything**

# Roadmap

### New Features (front end):
- [ ] Add banner on the feed, or something similar that signals more clearly what board the user is in (like in subreddits banners)
- [ ] †Image upload support
- [ ] UI component that 'protects' premium views/actions
- †Exposure boost
    - [ ] A premium-protected button in create and/or the user's profile for a limited amount of polls (per day) that boosts/promotes it in the feed
    - [ ] Pinned polls on boards
    - [ ] Could be just a feature of premium for boosting and a pay per poll basis/'Buy Me a Jeremy' for promoted (idk what the financial model should be tbh but I don't think having tiers in premium makes sense at this point)
- Draft a personal profile page design and implement in the current user porfile tab
    - Profile Section:
        - [ ] Shows their name, number of polls posted/answered, member since ..., account/report status, profile pic/avatar (randomized fa icon for now???), etc.
        - [ ] †Badges/flairs for answering, creating, etc.
        - [ ] Maybe some sort of point system that encourages people to vote and create (snap score, reddit karma)
        - [ ] Move settings actions here and remove the modal from the navbar
        - [ ] Follow count?
    - [ ] Section with the user's popular polls with the results already showing
    - [ ] Remove histroy tab from the side bar and create another section with the user's voting history akin to above
    - [ ] †Download your poll's data to a .csv/.xlsx file (Apexcharts supports this, kinda)
    - [ ] †Some level of data insight (not as important but could through something minor together in the mean time to beef up premium features)
    - [ ] †Close and delete polls
    - †Repsonses to the user's own polls:
        - [ ] Dropdown/tab showing the list of users who publicly voted (Instagram stories)
        - [ ] A button beside a voter's name ("show vote") that annotes the results ui for that poll with that user's vote and/or some sort of text field with their response data
- Draft and create Payment page (need artist)
    - [ ] Copy
    - [ ] List current features offered and promised in the future
    - [ ] Stripe checkout implementation
- [ ] Abstract the user profile code so that it can be resued for when the user clicks on another user's profile



†premium feature - would be displayed as locked behind a subscription such that the locked icon leads to the payment page


# Notes

If login is too slow, note that we are currently:

- Querying user likes/dislikes on login
- Querying boards on login
