require 'praise_modal'
require 'praise_message'
require 'process_values'
require 'json'

class Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def create
    # Skip validation in tests
    if Rails.env.test? === false
      # Is this a valid Slack request?
      if invalid_signature!
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

  private
  # courtesy of jmanian on github
  # https://github.com/slack-ruby/slack-ruby-client/issues/238#issuecomment-442981145
  def invalid_signature!
    signing_secret = ENV['slack_secret_signature']
    version_number = 'v0' # always v0 for now
    timestamp = request.headers['X-Slack-Request-Timestamp']
    raw_body = request.body.read # raw body JSON string

    if Time.at(timestamp.to_i) < 5.minutes.ago
      # could be a replay attack
      render json: {}, status: :bad_request
      return true
    end

    sig_basestring = [version_number, timestamp, raw_body].join(':')
    digest = OpenSSL::Digest::SHA256.new
    hex_hash = OpenSSL::HMAC.hexdigest(digest, signing_secret, sig_basestring)
    computed_signature = [version_number, hex_hash].join('=')
    slack_signature = request.headers['X-Slack-Signature']

    if computed_signature != slack_signature
      render json: {}, status: :unauthorized
      return true
    end
    return false
  end
end
