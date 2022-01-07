require 'slack_verification'

class Api::UserController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_slack

  def create
    options = Array.new
    user_list.each { |user|
      display_name = user_name(user)
      if display_name.present?
        options << {
          text: {
          type: "plain_text",
          text: display_name
          },
          value: formatted_slack_name(user)
        }
      end
    }
    render json: {
      options: options
    }.to_json
  end

  private

  def validate_slack
    SlackVerification.validate_slack!(request)
  end

  def payload
    if params[:payload].present?
      JSON.parse(params[:payload], :symbolize_names => true)
    else
      nil
    end
  end

  def search
    if payload.present?
      payload[:value]
    else
      nil
    end
  end

  def team_id
    @team_id ||= payload[:view][:team_id]
  end

  def user_list
    if search.present?
      User.where(is_deleted: false, team_id: team_id).where("display_name ILIKE '%#{search}%' OR actual_name ILIKE '%#{search}%'").order('display_name asc')
    else
      User.all.where(is_deleted: false, team_id: team_id).order('display_name asc')
    end
  end

  def formatted_slack_name(user)
    if user[:is_group].present?
      "<!subteam^#{user[:slack_id]}>"
    else
      "<@#{user[:slack_id]}>"
    end
  end

  def user_name(user)
    if user[:display_name].present?
      "#{user[:display_name]} (#{user[:actual_name]})"
    else
      "#{user[:actual_name]}"
    end
  end

end