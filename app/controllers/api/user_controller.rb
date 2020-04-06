class Api::UserController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @list = User.all
    options = Array.new
    @list.each { |user|
      options << {
        text: {
        type: "plain_text",
        text: "#{user.display_name} (#{user.actual_name})"
        },
        value: user.slack_id
      }
    }
    render json: {
      options: options
    }.to_json
  end

end