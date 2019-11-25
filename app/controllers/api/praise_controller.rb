require 'praise_modal'
require 'take_response'

class  Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def create
    case
    when params[:type]=="view_submission" && params[:view][:callback_id]=="submit_praise"
      # recieved submission
      TakeResponse.format(params[:view][:state][:values], params[:user])
    when params[:trigger_id]
      # trigger_id sent by /praise
      PraiseModal.open(params[:trigger_id])
    end
  end
end
