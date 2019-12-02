require 'praise_bot'

class PraiseMessage
  def self.build(values, view_id, user)
    Rails.logger.info("View submitted by #{user[:username]}")

    @view = View.find_by({ view_id: view_id })
    if @view.nil?
      # throw error
      Rails.logger.error("View not found.")
      return
    end

    headline = values['headlineblock']['headline']['value']
    comments = values['detailsblock']['details']['value']
    submitter = user['id']

    @view.assign_attributes({
      headline: headline,
      details: comments
    })

    errors = validate_view(@view)
    if !errors.blank?
      return errors.each_with_object({}) do | error, object |
        object["#{error[:key]}"] = "#{error[:message]}"
      end
    end

    emoji = @view.emoji
    users_list = @view.user_selection.join(", ")
    values_list = @view.value_selection.join(" | ")

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

    @view.save
    PraiseBot.submit(message_blocks, @view)
  end

  def self.destroy(view_id)
    @view = View.find_by({ view_id: view_id })
    if @view.delete
      Rails.logger.info("View #{view_id} destroyed.")
    else
      Rails.logger.error("Could not destroy view #{view_id}.")
    end
  end

  private
  def self.validate_view(view)
    errors = []

    if view.emoji.blank?
      errors << { key: "emojiblock", message: "An emoji selection is required." }
    end
    # if view.headline.blank?
    #   errors << { key: "headlineblock", message: "A headline is required." }
    # end
    # if view.details.blank?
    #   errors << { key: "detailsblock", message: "More information is required. Be specific about what they did, when, and why it's awesome!" }
    # end
    # if view.user_selection.blank?
    #   errors << { key: "userblock", message: "You need to select at least one user to praise." }
    # end
    # if view.user_selection.present? && view.user_selection.include?("<@#{view.slack_user_id}>")
    #   errors << { key: "userblock", message: "You can't praise yourself! :)" }
    # end
    # if view.value_selection.blank?
    #   errors << { key: "valueblock", message: "You need to select at least one value." }
    # end

    errors
  end
end