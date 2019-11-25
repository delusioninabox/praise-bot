class PraiseBot
  require 'json'

  def self.submit(message)
    token = ENV["slack_bot_auth"]
    # TODO: submit to kudos channel
  end
end