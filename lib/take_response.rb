require 'praise_bot'

class TakeResponse
  def self.format_message(values, view_id, user)
    Rails.logger.info("View submitted by #{user[:username]}")

    @view = View.find_by({ view_id: view_id })
    if @view.nil?
      # throw error
      Rails.logger.info("View not found.")
      return
    end

    emoji = @view.emoji
    headline = values['headline_block']['headline']['value']
    users_list = @view.user_selection.join(", ")
    values_list = @view.value_selection.join(" | ")
    comments = values['details_block']['details']['value']
    submitter = user['id']

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

  def self.save_action(actions, view_id, user)
    @view = View.find_by({ view_id: view_id })
    if @view.nil?
      @view = View.new({ view_id: view_id, slack_user_id: user['id'] })
    end

    actions.each_with_object({}) do |object, map|
      key = object['action_id'].to_sym
      case
      when object['type'] == 'multi_static_select'
        value = object['selected_options'].each_with_object([]) do |selection, array|
          array << selection['value']
        end
      when object['type'] == 'static_select'
        value = object['selected_option']['value']
      when object['type'] == 'multi_users_select'
        value = object['selected_users'].each_with_object([]) do |user, array|
          array << "<@#{user}>"
        end
      else
        value = object['value']
      end
      @view.update_attributes({ key => value })
    end

    if @view.save
      Rails.logger.info("Actions saved for view #{view_id}")
      Rails.logger.info("View: #{@view.inspect}")
    else
      Rails.logger.info("Actions could not be saved for view #{view_id}")
    end
  end
end