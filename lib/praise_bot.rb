class PraiseBot
  require 'json'

  def self.submit(message_blocks, view)
    token = ENV["slack_bot_auth"]
    channel = ENV["slack_praise_channel"]
    begin
      Rails.logger.info("Sending kudos message to Slack Channel.")
      options = {
        :body => {
          :token => token,
          :channel => channel,
          :text => "",
          :blocks => message_blocks
        }.to_json,
        :headers => {
          'Content-Type' => 'application/json; charset=utf-8',
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }
      }
      url = 'https://slack.com/api/chat.postMessage'
      response = HTTParty.post(url, options)
      view.update({
        posted: true
      })
      puts response.as_json
    rescue => e
      puts e
    end
  end
end