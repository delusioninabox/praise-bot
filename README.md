# README

Ruby Version:
Rails Version:

## Installing Repo
Run `bundle install`
Run `rake db:setup && db:migrate`
TBD

## Adding To Heroku
Deploy your app to Heroku or another site.

## Adding To Slack
Create a new App to your workspace for Praise Bot.

### The Bot
Add a bot user under Features & Functionality. Then go to `OAuth & Permissions` to find your bot's auth key.

Run `bundle exec figaro install` to generate a `config/application.yml` file.

Add your ENV variables to this file locally:
`slack_bot_auth: xoxb-xxxxxxx-xxxxxx-xxxxxx`

Replace with your keys. Add these in your deployed environment also.

_Do NOT commit this file._
