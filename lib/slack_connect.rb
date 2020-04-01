class SlackConnect
  require 'json'

  def self.get(slack_method, limit, page)
    token = ENV["slack_bot_auth"]
    begin
      Rails.logger.info("Retrieving from #{slack_method}")
      url = "https://slack.com/api/methods/#{slack_method}?token=#{token}"
      if limit.present?
        url += "&limit=#{limit}"
      end
      if page.present?
        url+= "&cursor=#{page}"
      end
      response = HTTParty.get(url)
      return response.body
    rescue => e
      puts e
      return null
    end
  end
end