require 'praise_modal'
require 'take_response'

class  Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def create
    case
    when params[:type]=="block_actions"
      # save selects and other interactive elements
      puts params.as_json
      TakeResponse.save(params[:actions], params[:view][:id], params[:user])
    when params[:type]=="view_submission" && params[:view][:callback_id]=="submit_praise"
      # recieved submission
      TakeResponse.format(params[:view][:state][:values], params[:view][:id], params[:user])
    when params[:trigger_id]
      # trigger_id sent by /praise
      PraiseModal.open(params[:trigger_id])
    end
  end
end
