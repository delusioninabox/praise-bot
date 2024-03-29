require 'praise_bot'

class PraiseMessage

  # Validate submission
  def self.build(values, view_id, team_id, user)
    Rails.logger.info("View submitted by #{user[:username]}")

    # Do we have the view?
    # We should b/c of required dropdowns
    @view = View.find_by({ view_id: view_id, team_id: team_id })
    if @view.nil?
      # If not, create one
      @view = View.new({ view_id: view_id, team_id: team_id, slack_user_id: user[:id] })
    end

    # Process & save submitted values
    @view = ProcessValues.save(values, @view)
    Rails.logger.info("View: #{@view}")

    # Check all information is inputted & correct
    errors = validate_view(@view)
    if !errors.blank?
      # if errors, return
      # format is "block_id": "error message"
      return errors.each_with_object({}) do | error, object |
        object["#{error[:key]}"] = "#{error[:message]}"
      end
    end

    message = build_message(@view)

    # Post to Slack channel
    PraiseBot.submit(message, @view)
  end

  # Delete a view if it exists
  def self.destroy(view_id)
    @view = View.find_by({ view_id: view_id })
    if @view.present? && @view.delete
      Rails.logger.info("View #{view_id} destroyed.")
    else
      Rails.logger.error("Could not destroy view #{view_id}.")
    end
  end

  private
  # Validation check
  def self.validate_view(view)
    errors = []

    if view.emoji.blank?
      errors << { key: "emoji-block", message: "An emoji selection is required." }
    end
    if view.headline.blank?
      errors << { key: "headline-block", message: "A headline is required." }
    end
    if view.details.blank?
      errors << { key: "details-block", message: "More information is required. Be specific about what they did, when, and why it's awesome!" }
    end
    if view.image_url.present? && !view.image_url.match(%r{.(gif|jpg|png)\Z}i)
      errors << { key: "image-url-block", message: "Must be a URL for GIF, JPG or PNG image." }
    end
    if view.user_selection.blank?
      errors << { key: "user-block", message: "You need to select at least one user to praise." }
    end
    if view.user_selection.present? && view.user_selection.include?("<@#{view.slack_user_id}>")
      errors << { key: "user-block", message: "You can't praise yourself! :)" }
    end

    # return errors
    errors
  end

  def self.get_values(view)
    case
    when view.value_selection.present? && view.custom_values.present?
      # Both selections + custom
      "#{view.value_selection.join(" | ")} | #{view.custom_values}"
    when view.value_selection.blank? && view.custom_values.present?
      # Just custom
      view.custom_values
    when view.value_selection.present? && view.custom_values.blank?
      # Just selections
      view.value_selection.join(" | ")
    else
      nil
    end
  end

  def self.build_message(view)
    # Process values
    headline = view.headline
    comments = view.details
    emoji = view.emoji
    image_url = view.image_url
    users_list = view.user_selection.join(", ")
    value_list = get_values(view)
    submitter = view.slack_user_id


    # Build message
    message_blocks = [
      {
        "type": "header",
        "text": {
          "type": "plain_text",
          "text": ":#{emoji}: #{headline} :#{emoji}:",
          "emoji": true
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "#{users_list}"
        }
      }
    ];
    if image_url.present?
      message_blocks.push(
        {
          "type": "image",
          "image_url": "#{image_url}",
          "alt_text": "An image has been attached to this kudos!"
        }
      )
    end
    message_blocks.push(
      {
        "type": "divider"
      }
    )
    if value_list.present?
      message_blocks.push(
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "#{value_list}"
        }
      },
      {
        "type": "divider"
      });
    end
    message_blocks.push(
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
    );
  end
end