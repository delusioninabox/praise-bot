require 'praise_modal'
require 'praise_message'
require 'process_values'
require 'slack_verification'
require 'json'

class Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def create
    # Skip validation in tests or local
    unless Rails.env.test? || Rails.env.development?
      # Is this a valid Slack request?
      if SlackVerification.invalid_signature!(request)
        render json: {}, status: :unauthorized
        return
      end
    end

    # Only some requests from Slack include a nested `payload`
    # It needs to be parsed from a JSON string
    if params[:payload]
      payload = JSON.parse(params[:payload])
      view = payload['view']
    end

    # Determine what method to call
    case
    when params[:trigger_id]
      # User typed /praise command
      PraiseModal.open(params[:trigger_id])

    when payload['type']=="view_submission" && view['callback_id']=="submit_praise"
      # User hit "submit"
      # PraiseMessage.build to return error object
      errors_object = PraiseMessage.build(view['state']['values'], view['id'], payload['user'])
      if !errors_object.blank?
        # Tell Slack to display field errors
        Rails.logger.error("Errors: #{errors_object.as_json}")
        return render :json => {
          :response_action => "errors",
          :errors => errors_object
        }
      else
        # Tells Slack to close the view/modal
        return render :json => {
          "response_action": "clear"
        }
      end

    when payload['type']=="view_closed" && view['callback_id']=="submit_praise"
      # User hit cancel
      PraiseMessage.destroy(view['id'])
    end

  end
end
