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
      @list = User.where("display_name ILIKE '%#{search}%' OR actual_name ILIKE '%#{search}%'").order('display_name asc')
    else
      @list = User.all.order('display_name asc')
    end
    options = Array.new
    @list.each { |user|
      options << {
        text: {
        type: "plain_text",
        text: "#{user.display_name} (#{user.actual_name})"
        },
        value: user.slack_id
      }
    }
    render json: {
      options: options
    }.to_json
  end

end