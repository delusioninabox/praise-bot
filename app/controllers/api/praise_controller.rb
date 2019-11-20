require 'praise_modal'

class  Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # First check if Slack validating
    # Or sending information to process
    puts params.to_json
    case
    when params[:challenge]
      # Verify to Slack
      render :json => {challenge: params[:challenge]}, :status => :ok
    when params[:trigger_id]
      # If Open Modal Trigger
      PraiseModal.open(params[:trigger_id])
    end
  end
end
