require 'praise_modal'

class  Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    case
    when params[:trigger_id]
      # trigger_id sent by /praise
      PraiseModal.open(params[:trigger_id])
    end
  end
end
