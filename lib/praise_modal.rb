class PraiseModal
  require 'json'

  def self.open(trigger_id)
    token = ENV["slack_bot_auth"]
    begin
      Rails.logger.info("Opening praise modal")
      file = File.read('assets/dialog.json')
      options = {
        :body => {
          token: token,
          :trigger_id => trigger_id,
          :dialog => JSON.parse(file)
        }.to_json,
        :headers => {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      }
      url = 'https://slack.com/api/dialog.open'
      response = HTTParty.post(url, options)
      puts response.to_json
    rescue => e
      puts e
    end
  end
end