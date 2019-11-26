require 'praise_modal'
require 'take_response'
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
    when payload['type']=="block_actions"
      # save selects and other interactive elements
      TakeResponse.save(payload['actions'], view['id'], payload['user'])
    when payload['type']=="view_submission" && view['callback_id']=="submit_praise"
      # recieved submission
      TakeResponse.format(view['state']['values'], view['id'], payload['user'])
    when params[:trigger_id]
      # trigger_id sent by /praise
      PraiseModal.open(params[:trigger_id])
    end
  end
end
