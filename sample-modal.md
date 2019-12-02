# Modal Form

`POST` to `https://slack.com/api/dialog.open`
Send `token`
Send `trigger_id`
Send `dialog` (below)
```
{
  "callback_id": "tbd",
  "title": ":raised_hands: Praise Your Team! :raised_hands:",
  "submit_label": "Send Praise! :rocket:",
  "state": "--",
  "blocks": [
    {
      "type": "section",
      "block_id": "section678",
      "text": {
        "type": "mrkdwn",
        "text": "*I want to praise:*"
      },
      "accessory": {
        "action_id": "text1234",
        "type": "multi_users_select",
        "placeholder": {
          "type": "plain_text",
          "text": "Select user(s)"
        }
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Because they are...*"
      },
      "accessory": {
        "type": "static_select",
        "placeholder": {
          "type": "plain_text",
          "text": "Select an item",
          "emoji": true
        },
        "options": [
          {
            "text": {
              "type": "plain_text",
              "text": "🎉 amazing!",
              "emoji": true
            },
            "value": "tada"
          },
          {
            "text": {
              "type": "plain_text",
              "text": "🤗 helpful",
              "emoji": true
            },
            "value": "hugging"
          },
          {
            "text": {
              "type": "plain_text",
              "text": "🙏 a lifesaver",
              "emoji": true
            },
            "value": "praying"
          }
        ]
      }
    },
    {
      "type": "input",
      "element": {
        "type": "plain_text_input"
      },
      "label": {
        "type": "plain_text",
        "text": "In a few words: (headline)",
        "emoji": true
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*They exhibited:*"
      },
      "accessory": {
        "type": "multi_static_select",
        "placeholder": {
          "type": "plain_text",
          "text": "Select value(s)",
          "emoji": true
        },
        "options": [
          {
            "text": {
              "type": "plain_text",
              "text": "Courage",
              "emoji": true
            },
            "value": "courage"
          },
          {
            "text": {
              "type": "plain_text",
              "text": "Creativity",
              "emoji": true
            },
            "value": "creativity"
          },
          {
            "text": {
              "type": "plain_text",
              "text": "Empathy",
              "emoji": true
            },
            "value": "empathy"
          },
          {
            "text": {
              "type": "plain_text",
              "text": "Humility",
              "emoji": true
            },
            "value": "humility"
          },
          {
            "text": {
              "type": "plain_text",
              "text": "Passion",
              "emoji": true
            },
            "value": "passion"
          }
        ]
      }
    },
    {
      "type": "input",
      "element": {
        "type": "plain_text_input",
        "action_id": "ml_input",
        "multiline": true,
        "placeholder": {
          "type": "plain_text",
          "text": "Tell us more! (optional)"
        }
      },
      "label": {
        "type": "plain_text",
        "text": "Details"
      },
      "hint": {
        "type": "plain_text",
        "text": "Be specific about what they did that was so awesome!"
      }
    },
    {
      "type": "input",
      "element": {
        "type": "channels_select",
        "placeholder": {
          "type": "plain_text",
          "text": "Select a channel",
          "emoji": true
        }
      },
      "label": {
        "type": "plain_text",
        "text": "Share this to:",
        "emoji": true
      }
    }
  ]
}
```

## Sample Response
Type `view_submission` is when the submit button is hit.
Type `block_actions` will also run when the form is updated.
```
{
  "type": "view_submission",
  "team": {
    "id": "XXXXXXXXX",
    "domain": "testslack"
  },
  "user": {
    "id": "XXXXXXXXX",
    "username": "laura",
    "name": "laura",
    "team_id": "XXXXXXXXX"
  },
  "api_app_id": "XXXXXXXXX",
  "token": "XXXXXXXXX",
  "trigger_id": "XXXXXXXXX.XXXXXXXXX.XXXXXXXXXXXXXXXXXX",
  "view": {
    "id": "XXXXXXXXX",
    "team_id": "XXXXXXXXX",
    "type": "modal",
    "blocks": [
      // ...
      // same as in view.open
      // ...
    ],
    "private_metadata": "",
    "callback_id": "submit_praise",
    "state": {
      "values": {
        "headline-block": { // block_id
          "headline": { // action_id
            "type": "plain_text_input",
            "value": "Test Headline"
          }
        },
        "details_block": { // block_id
          "details": { // action_id
            "type": "plain_text_input",
            "value": "Here are some details!"
          }
        }
      }
    },
    "hash": "XXXXXXXXX.XXXXXXXXX",
    "title": {
      "type": "plain_text",
      "text": "Give kudos! :clap:",
      "emoji": true
    },
    "clear_on_close": false,
    "notify_on_close": false,
    "close": null,
    "submit": {
      "type": "plain_text",
      "text": "Submit :rocket:",
      "emoji": true
    },
    "previous_view_id": null,
    "root_view_id": "XXXXXXXXX",
    "app_id": "XXXXXXXXX",
    "external_id": "",
    "app_installed_team_id": "XXXXXXXXX",
    "bot_id": "XXXXXXXXX"
  }
}
```