require 'praise_modal'
require 'praise_message'
require 'slack_actions'
require 'json'

class  Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def create
    if params[:payload]
      payload = JSON.parse(params[:payload])
      view = payload['view']
    end
    case
    when params[:trigger_id]
      # trigger_id sent by /praise
      PraiseModal.open(params[:trigger_id])
    when payload['type']=="block_actions"
      # save selects and other interactive elements
      SlackActions.save(payload['actions'], view['id'], payload['user'])
    when payload['type']=="view_submission" && view['callback_id']=="submit_praise"
      # recieved submission
      errors_object = PraiseMessage.build(view['state']['values'], view['id'], payload['user'])
      if !errors_object.blank?
        Rails.logger.error("Errors: #{errors_object.as_json}")
        render :json => {
          "response_action": "errors",
          "errors": errors_object
        }
      else
        render :json => {
          "response_action": "clear"
        }
      end
    when payload['type']=="view_closed" && view['callback_id']=="submit_praise"
      # modal canceled
      PraiseMessage.destroy(view['id'])
    end
  end
end
