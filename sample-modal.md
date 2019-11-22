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

Sample Response:
```
{
  "type": "view_submission",
  "team": {
    "id": "xxxxxxx",
    "domain": "teamname"
  },
  "user": {
    "id": "xxxxxxx",
    "username": "laura",
    "name": "laura",
    "team_id": "xxxxxxx"
  },
  "api_app_id": "xxxxxxx",
  "token": "xxxxxxx",
  "trigger_id": "xxxxxxx.xxxxxxx.xxxxxxxxxxxxx",
  "view": {
    "id": "xxxxxxx",
    "team_id": "xxxxxxx",
    "type": "modal",
    "blocks": [
      {
        "type": "section",
        "block_id": "user_block",
        "text": {
          "type": "mrkdwn",
          "text": "*I want to praise:*",
          "verbatim": false
        },
        "accessory": {
          "type": "multi_users_select",
          "action_id": "users",
          "placeholder": {
            "type": "plain_text",
            "text": "Select user(s)",
            "emoji": true
          }
        }
      },
      {
        "type": "input",
        "block_id": "gco",
        "label": {
          "type": "plain_text",
          "text": "*In a few words:*",
          "emoji": true
        },
        "optional": false,
        "element": {
          "type": "plain_text_input",
          "action_id": "y8Z"
        }
      },
      {
        "type": "section",
        "block_id": "dNURN",
        "text": {
          "type": "mrkdwn",
          "text": "*Choose an emoji:* (displays with your headline)",
          "verbatim": false
        },
        "accessory": {
          "type": "static_select",
          "placeholder": {
            "type": "plain_text",
            "text": "Select an emoji",
            "emoji": true
          },
          "options": [
            {
              "text": {
                "type": "plain_text",
                "text": "🎉",
                "emoji": true
              },
              "value": "tada"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "🤗",
                "emoji": true
              },
              "value": "hugging"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "🙏",
                "emoji": true
              },
              "value": "praying"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "🔥",
                "emoji": true
              },
              "value": "fire"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "💥",
                "emoji": true
              },
              "value": "boom"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "🙌",
                "emoji": true
              },
              "value": "raised_hands"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "🌟",
                "emoji": true
              },
              "value": "star2"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "✨",
                "emoji": true
              },
              "value": "sparkles"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "❤",
                "emoji": true
              },
              "value": "heart"
            }
          ],
          "action_id": "2dlJ0"
        }
      },
      {
        "type": "section",
        "block_id": "GaC=",
        "text": {
          "type": "mrkdwn",
          "text": "*They exhibited:*",
          "verbatim": false
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
                "text": "💪 Courage",
                "emoji": true
              },
              "value": "courage"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "🧠 Creativity",
                "emoji": true
              },
              "value": "creativity"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "❤ Empathy",
                "emoji": true
              },
              "value": "empathy"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "😇 Humility",
                "emoji": true
              },
              "value": "humility"
            },
            {
              "text": {
                "type": "plain_text",
                "text": "🌟 Passion",
                "emoji": true
              },
              "value": "passion"
            }
          ],
          "action_id": "7QQ"
        }
      },
      {
        "type": "input",
        "block_id": "k8H",
        "label": {
          "type": "plain_text",
          "text": "Details",
          "emoji": true
        },
        "hint": {
          "type": "plain_text",
          "text": "Be specific about what they did that was so awesome!",
          "emoji": true
        },
        "optional": false,
        "element": {
          "type": "plain_text_input",
          "action_id": "ml_input",
          "placeholder": {
            "type": "plain_text",
            "text": "Tell us more!",
            "emoji": true
          },
          "multiline": true
        }
      }
    ],
    "private_metadata": "",
    "callback_id": "submit_praise",
    "state": {
      "values": {
        "gco": {
          "y8Z": {
            "type": "plain_text_input",
            "value": "test headline"
          }
        },
        "k8H": {
          "ml_input": {
            "type": "plain_text_input",
            "value": "test details"
          }
        }
      }
    },
    "hash": "xxxxxxx.xxxxxxx",
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
    "root_view_id": "xxxxxxx",
    "app_id": "xxxxxxx",
    "external_id": "",
    "app_installed_team_id": "xxxxxxx",
    "bot_id": "xxxxxxx"
  }
}
```