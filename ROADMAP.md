# Development Roadmap

- [Master Checklist](https://docs.google.com/spreadsheets/d/1_l05MRtndCjIhHvqixORiueiIIFqz9E6iD2b9xADoRE/edit?usp=sharing) (contains non-technical items as well)
- [Database Schema](https://drive.google.com/file/d/1miwHyiKxAsvqpu6lSzgJPm7c2lLgoC4g/view?usp=drive_link)

## Pull Requests

These are development items that I think someone other than me (Riley) could do. If you are going to take on one of these, please create a branch, and then submit a pull request when you are finished. Most of these tasks involve working with the UI and should involve little to no back-end development.

| ID  | Difficulty | Task                                                                    | Status    |
| --- | ---------- | ----------------------------------------------------------------------- | --------- |
| 1   | 3/10       | Ensure UI can handle unusually long questions and answers.              | Unclaimed |
| 2   | 4/10       | Make tier list expand when line is full.                                | Unclaimed |
| 3   | 2/10       | Replace radio/checkbox in the choose one/many interface with boxes.     | Unclaimed |
| 4   | 3/10[^2]   | Add light-mode compatible logo.                                         | Unclaimed |
| 5   | 3/10       | Improving the Poll UI with share link, "created by", and report button. | Unclaimed |
| 6   | 4/10       | Ensure compatibility with different screen sizes with CSS breakpoints.  | Unclaimed |
| 7   | 7/10[^1]   | Add a nice abstraction to `responses.py` to reduce code duplication.    | Unclaimed |
| 8   | 7/10[^1]   | Add a nice abstraction to `results.py` to reduce code duplication.      | Unclaimed |
| 9   | 4/10       | Add a countdown to the `/create` endpoint when a user creates a poll.   | Unclaimed |
| 10  | 6/10[^3]   | Make the ranked poll interface look nice. Improve UI.                   | Unclaimed |
| 11  | 8/10[^3]   | Ensure the tier list properly handles many items. Improve UI.           | Unclaimed |

[^1]: Requires working with SQL queries in the back-end.

[^2]: In addition to an SVG file containing the new logo, this pull request may also implement switching between logos depending on the `localStorage.theme` variable. This variable is updated when the user toggles light/dark mode. In the appropriate template file, add an `id` to the logo element. Then in `dark-mode.js`, update the event listener so that on page load, the correct logo gets displayed. Additionally, you will need to update the `setLightMode()` and `setDarkMode()` functions so that the logo changes when somebody clicks the light/dark mode toggle.

[^3]: Requires a willingness to work with some fairly advanced CSS concepts (flexbox) and some tricky Javascript ([drag and drop](https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API)).

## 1: Minimum Viable App

- [ ] Fix Feed/History/My Polls
- [ ] Administrator Dashboard
- [ ] Reports
- [ ] Custom Results Interface
  - [ ] Choose One
  - [ ] Choose Many
  - [ ] Numeric One
  - [ ] Numeric Star
  - [ ] Ranked Poll
  - [ ] Tier List
- [ ] Interoperability Features
  - [ ] Create a randomized URL for each poll that users can share.
  - [ ] Allow users to respond and see results anonymously from this URL.
  - [ ] After responding, the app recommends other polls and requires login.
- [ ] Poll Boards

## 2: Staging

- [ ] Push the app to Railway. Allow trusted people to test.
- [ ] Write unit tests.
- [ ] Test for security vulnerabilities (SQL injection, endpoint permissions)

## 3: Launch

- [ ] Deploy to Google Cloud Services
- [ ] Create a dashboard to manage application health and uptime
- [ ] Set up automatic alerts when errors occur on production

## 4: Minimum Viable product

- [AI-Powered Poll Tagging](https://docs.google.com/document/d/1knJN9BY2EJ27TZhUlEIYxNZZmU6g-eYaLxmL75ShN_U/edit?usp=drive_link)
- Poll Dashboard
- Payment Processing
