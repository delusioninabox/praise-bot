class SlackConnect
  require 'json'

  def self.get(slack_method, limit, page)
    token = ENV["slack_bot_auth"]
    begin
      Rails.logger.info("Retrieving from #{url}")
      url = 'https://slack.com/api/methods/' + slack_method + '?token=' + token
      if limit
        url += '&limit=' + limit
      end
      if page
        url+= '&cursor=' + page
      end
      response = HTTParty.get(url, options)
      return response.body
    rescue => e
      puts e
      return null
    end
  end
end