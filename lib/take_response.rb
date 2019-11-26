require 'praise_bot'

class TakeResponse
  def self.format(values, view_id, user)
    Rails.logger.info("View submitted by #{user[:username]}")

    @view = View.find({ view_id: view_id })
    if @view.empty?
      # throw error
      Rails.logger.info("View not found.")
      return
    end

    emoji = @view.emoji
    headline = values[:headline_block][:headline][:value]
    users_list = @view.user_selection
    values_list = @view.value_selection
    comments = values[:details_block][:details][:value]
    submitter = user[:id]

    @view.update({
      headline: headline,
      details: comments,
      posted: true
    })

    Rails.logger.info("View details: #{@view}")

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

  def self.save(actions, view_id, user)
    @view = View.where({ view_id: view_id })
    if @view.empty?
      @view = View.new({ view_id: view_id, slack_user_id: user['id'] })
    end

    actions.each_with_object({}) do |object, map|
      key = object['action_id']
      case
      when object['type'] == 'multi_static_select'
        value = object['selected_options'].each_with_object([]) do |selection, array|
          selection['value']
        end
      when object['type'] == 'static_select'
        value = object['selected_option']['value']
      when object['type'] == 'multi_users_select'
        value = object['selected_users']
      else
        value = object['value']
      end
      @view.attributes = { "#{key}": value }
    end

    if @view.save
      Rails.logger.info("Actions saved for view #{view_id}")
    else
      Rails.logger.info("Actions could not be saved for view #{view_id}")
    end
  end
end