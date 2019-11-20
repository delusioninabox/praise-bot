# Posting Praise

`POST` to `https://slack.com/api/chat.postMessage`

Send `token`
Send `channel`
Send `text`
Send `icon_url`
Send `username`
Send `block` (below)
```
{
	"blocks": [
        {
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": ":rotating_light: *PRAISE ALERT!* :rotating_light:\n----------------------------"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": ":tada: *Praise Headline Goes Here!* :tada:\n@user1, @user2"
			}
		},
		{
			"type": "divider"
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": ":heart: *empathy* | :innocent: *humility* | :muscle: *courage*"
            }
		},
		{
			"type": "divider"
		},
        {
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eu erat id arcu luctus lobortis. Donec dolor eros, finibus id eleifend ac, gravida sed orci. Duis faucibus purus quis augue aliquam rutrum. Aliquam ut nunc ultricies, ultrices eros et, ornare magna. Phasellus facilisis consectetur lacus vitae volutpat. Proin eget metus et nulla faucibus laoreet at in mi."
            }
        },
		{
			"type": "divider"
		},
        {
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "_Submitted by @sender_"
			}
		}
	]
}
```