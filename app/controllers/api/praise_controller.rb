class  Api::PraiseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # First check if Slack validating
    # Or sending information to process
    challenge = params[:challenge]
    if challenge
      # Verify to Slack
      render :json => {challenge: challenge}, :status => :ok
    elsif token
      # If Open Modal Trigger
      trigger_id = params[:trigger_id]
      if trigger_id
        PraiseModal.open(trigger_id)
      end
    end
  end
end
