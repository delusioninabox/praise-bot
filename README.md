# Slack Praise Bot
Give a shout-out or kudos to people in your Slack server! Uses a slash command to prompt open the form from any channel, and will post a formatted message in a single channel.

Ruby Version: `2.5.3p105`

Rails Version: `5.2.3`

Uses **Postgres** for the database, which saves submissions and those in-progress.

Run tests with `bundle exec rspec`.

## 1. Installing Repo
I recommend forking the repo so you can customize for your server's needs. For example, this view has a multi select for our company values. You may want to change these to your own values, or remove the block and validation if you don't wish to use it. Likewise, you may want to customize how the message displays. Forking will let you use this repo as a base for how to make the changes you need to suit your server!

1. Fork the repo & clone to your computer. Then navigate into the folder.

2. Run `bundle install`

3. Run `rake db:setup && db:migrate`

After finishing steps 3 and 4, you can run locally with `rails s`. The API can be found locally at `http://localhost:3000/api/praise`.

## 2. Adding To Heroku
Deploy your app to Heroku or another site. You can use Heroku's CLI, or deploy from your forked repo.

## 3. Adding To Slack
Create a new App to your workspace for Praise Bot.

## 4. The Bot
1. Add a bot user under `Features & Functionality`. Then go to `OAuth & Permissions` to find your bot's auth key.

2. Run `bundle exec figaro install` to generate a `config/application.yml` file.

3. Add your ENV variables to this file locally:
`slack_bot_auth: xoxb-xxxxxxx-xxxxxx-xxxxxx`

4. Replace the above value with your keys.

5. Also add a ENV variable with the channel ID to post to.
`slack_praise_channel: xxxxx`

**How do I get the channel ID?** If you go to the team's Slack in your browser, and then click into the channel you want to post to, the channel ID will be the last string after the last `/` in the URL.

Example: `https://app.slack.com/client/TEAM_ID/CHANNEL_ID`

Add these in your deployed environment also.

_**---- Do NOT commit this file. ----**_

## 5. Making The Bot Live
1. Back in the bot's Slack App settings, go to `Interactive Components`. Turn `interactivity` on and add a request URL with your deployed environment. It should look like this: `https://deployed-domain.com/api/praise`

2. Next go to `Slash Commands` and add a new slash command. Make the command `/praise` (or `/kudos` if you'd rather). *The request URL will be same as the URL you used above.*

Make sure it's installed in the team's workspace, you update bot's display name/image, and you're good to go!

## How It Works
1. A user, in any channel, can type `/praise` as a command.
2. Slack uses the API to hit our API's POST `PraiseController` (`/api/praise`), which processes all requests from Slack.
3. The controller calls `view.open` to Slack's API with the form built in `lib/assets/view.json`
4. Slack will open the modal form for the user.
5. **When the user selects a dropdown or interactive input**, Slack pings our API with a `block_action` request. Our API will save the value to the corresponding field and process the value based on the input type.
5. **When the user submits the form,** Slack sends a `view_submission` request. We first validate they've filled out all information quickly. **If fields are missing or invalid,** we return a list of errors to be displayed. If it is valid, we build the message format to post and submit to Slack.
6. **When the user hits cancel,** Slack sends a `view_closed` request. If we have their view saved -- because they filled out an input, for example -- we delete the incomplete view.

### Praise Controller
The praise controller is responsible only for handling POST requests from Slack, determining what response is required, and then calling the appropiate method.

### Library Methods
1. `PraiseBot.submit`: Posts the finalized message to the selected channel.
2. `PraiseMessage.build`: Validates the final submission and formats the message to post.
3. `PraiseMessage.destroy`: Deletes incomplete submissions.
4.  `SlackActions.save`: Saves values received in `block_action` requests.