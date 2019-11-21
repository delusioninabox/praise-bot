require 'praise_modal'

class  Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    puts params
    case
    when params[:trigger_id]
      # trigger_id sent by /praise
      PraiseModal.open(params[:trigger_id])
    when params[:payload]
      # trigger_id sent by action
      # trigger_id = params[:payload][:trigger_id]
      # PraiseModal.open(trigger_id)
    when params[:command]=="submit_praise"
      # recieving response
      puts "form submitted"
    end
  end
end
