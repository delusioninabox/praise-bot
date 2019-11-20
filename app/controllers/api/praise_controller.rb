class  Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # First check if Slack validating
    # Or sending information to process
    challenge = params[:challenge]
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
