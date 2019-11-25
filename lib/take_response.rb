require 'praise_bot'

class TakeResponse
  def self.format(values, view_id, user)
    Rails.logger.info("Received values: #{values} from #{user[:username]}")

    @slack_view = View.find({ view_id: view_id })

    emoji = @slack_view.emoji
    headline = values[:headline_block][:headline][:value]
    users_list = @slack_view.user_selection
    values_list = @slack_view.value_selection
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

  def self.save(actions, view_id)
    @slack_view = View.find({ view_id: view_id })
    actions.each_with_object({}) do |object, map|
      key = object[:action_id]
      map[key] = object[:value]
    end
    if @slack_view.present?
      @slack_view.update({ emoji: actions[:emoji], user_selection: actions[:users], value_selection: actions[:values] })
    else
      View.create({ view_id: view_id, emoji: actions[:emoji], user_selection: actions[:users], value_selection: actions[:values] })
    end
  end
end