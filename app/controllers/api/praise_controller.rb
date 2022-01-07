require 'praise_modal'
require 'praise_message'
require 'process_values'
require 'slack_verification'
require 'json'

class Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_slack
  layout false

  def create
    # Determine what method to call
    case
    when open_model?
      # User typed /praise command
      PraiseModal.open(params[:trigger_id])

    when user_submitted?
      # User hit "submit"
      # PraiseMessage.build to return error object
      errors = PraiseMessage.build(model_state, view_id, team_id, user)
      if !errors.blank?
        log_errors(errors)
      else
        # Tells Slack to close the view/modal
        close_model()
      end

    when user_canceled?
      # User hit cancel
      PraiseMessage.destroy(view_id)
    end

  end

  private

  def validate_slack
    SlackVerification.validate_slack!(request)
  end

  # Decoded Response Definitions
  def payload
    @payload ||= params[:payload].present? ? JSON.parse(params[:payload], :symbolize_names => true) : params[:payload]
  end

  def view
    # Only some requests from Slack include a nested `payload`
    # It needs to be parsed from a JSON string
    @view ||= payload.present? ? payload[:view] : nil
  end

  # Specific Reference Definitions
  def callback_id
    @callback_id ||= view[:callback_id]
  end

  def payload_type
    @payload_type ||= payload[:type]
  end

  def view_id
    @view_id ||= view[:id]
  end

  def team_id
    @team_id ||= view[:team_id]
  end

  def model_state
    @model_state ||= view[:state][:values]
  end

  def user
    user ||= payload[:user]
  end

  # Methods
  def open_model?
    params[:trigger_id].present?
  end

  def user_submitted?
    payload_type=="view_submission" && callback_id=="submit_praise"
  end

  def user_canceled?
    payload_type=="view_closed" && callback_id=="submit_praise"
  end

  def log_errors(errors)
    # Tell Slack to display field errors
    Rails.logger.error("Errors: #{errors.as_json}")
    return render :json => {
      :response_action => "errors",
      :errors => errors
    }
  end

  def close_model
    return render :json => {
      "response_action": "clear"
    }
  end
end
