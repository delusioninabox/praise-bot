class PraiseModal
  require 'json'

  def self.open(trigger_id)
    token = ENV["slack_bot_auth"]
    begin
      Rails.logger.info("Opening praise modal.")
      file = File.read(Rails.root + 'lib/assets/dialog.json')
      options = {
        :body => {
          :token => token,
          :trigger_id => trigger_id,
          :dialog => JSON.parse(file)
        }.to_json,
        :headers => {
          'Content-Type' => 'application/json; charset=utf-8',
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }
      }
      url = 'https://slack.com/api/views.open'
      Rails.logger.info("Sending to Slack...")
      puts options.to_json
      response = HTTParty.post(url, options)
      puts response.to_json
    rescue => e
      puts e
    end
  end
end