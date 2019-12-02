require 'praise_bot'

class PraiseMessage
  def self.format_message(values, view_id, user)
    Rails.logger.info("View submitted by #{user[:username]}")

    @view = View.find_by({ view_id: view_id })
    if @view.nil?
      # throw error
      Rails.logger.error("View not found.")
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

  def self.destroy(view_id, user)
    @view = View.find_by({ view_id: view_id })
    if @view.delete
      Rails.logger.info("View #{view_id} destroyed by #{user.username}.")
    else
      Rails.logger.error("Could not destroy view #{view_id}.")
    end
  end
end