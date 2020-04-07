require 'slack_verification'

class Api::UserController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Skip validation in tests and local
    unless Rails.env.test? || Rails.env.development?
      # Is this a valid Slack request?
      if SlackVerification.invalid_signature!(request)
        render json: {}, status: :unauthorized
        return
      end
    end

    if params[:payload].present?
      payload = JSON.parse(params[:payload], :symbolize_names => true)
      search = payload[:value]
    end
    if search.present?
      @list = User.where(is_deleted: false).where("display_name ILIKE '%#{search}%' OR actual_name ILIKE '%#{search}%'").order('display_name asc')
    else
      @list = User.all.where(is_deleted: false).order('display_name asc')
    end
    options = Array.new
    @list.each { |user|
      if user[:is_group]
        formatted_value = "<!subteam^#{user.slack_id}>"
      else
        formatted_value = "<@#{user.slack_id}>"
      end
      if user.display_name.present?
        display_message = "#{user.display_name} (#{user.actual_name})"
      else
        display_message = "#{user.actual_name}"
      end
      if display_message.present?
        options << {
          text: {
          type: "plain_text",
          text: display_message
          },
          value: formatted_value
        }
      end
    }
    render json: {
      options: options
    }.to_json
  end

end