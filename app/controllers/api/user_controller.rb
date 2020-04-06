require 'slack_verification'

class Api::UserController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    # Skip validation in tests
    unless Rails.env.test?
      # Is this a valid Slack request?
      if SlackVerification.invalid_signature!
        return
      end
    end

    search = params[:query]
    if search.present?
      @list = User.where("display_name ILIKE '%#{search}%' OR actual_name ILIKE '%#{search}%'").order('display_name asc')
    else
      @list = User.all.order('display_name asc')
    end
    options = Array.new
    @list.each { |user|
      display = user.display_name
      actual = user.actual_name
      if search.present?
        display = display.gsub(/#{search}/i, "*#{search}*")
        actual = actual.gsub(/#{search}/i, "*#{search}*")
      end
      options << {
        text: {
        type: "plain_text",
        text: "#{display} (#{actual})"
        },
        value: user.slack_id
      }
    }
    render json: {
      options: options
    }.to_json
  end

end