require 'praise_bot'

class TakeResponse
  def self.format(values, user)
    Rails.logger.info("Received values: #{values} from #{user[:username]}")
    # loop through values for each [:block_id] and then [:action_id]
    # (or just extract the block/action IDs since we know what they are)
    emoji = values[:emoji]
    headline = values[:headline_block][:headline][:value]
    users_list = values[:users_list]
    values_list = values[:values_list]
    comments = values[:details_block][:details][:value]
    submitter = user[:id]

    message_blocks = [
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
          "text": ":#{emoji}: *#{headline}* :#{emoji}:\n#{users_list}"
        }
      },
      {
        "type": "divider"
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "#{values_list}"
              }
      },
      {
        "type": "divider"
      },
          {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "#{comments}"
              }
          },
      {
        "type": "divider"
      },
          {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "_Submitted by <@#{submitter}>_"
        }
      }
    ]

    PraiseBot.submit(message_blocks)
  end
end