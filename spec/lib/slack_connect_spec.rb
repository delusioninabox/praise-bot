RSpec.describe SlackConnect do

  context '.get' do
    let(:slack_method) { 'users.list' }
    let(:limit) { 100 }
    let(:page) { '' }
    let(:slack_response) { instance_double(HTTParty::Response, body: slack_response_body) }
    let(:slack_response_body) { 'response_body' }

    it 'calls users.list with no limit or next page request' do
      cached_slack_token = ENV["slack_bot_auth"]
      ENV["slack_bot_auth"] = "12345"
      limit = nil
      allow(HTTParty).to receive(:get).
        with('https://slack.com/api/methods/users.list?token=12345').
        and_return(slack_response)
      subject.class.get(slack_method, limit, page)
      ENV["slack_bot_auth"] = cached_slack_token
    end


    it 'calls users.list with limit' do
      cached_slack_token = ENV["slack_bot_auth"]
      ENV["slack_bot_auth"] = "12345"
      allow(HTTParty).to receive(:get).
        with('https://slack.com/api/methods/users.list?token=12345&limit=100').
        and_return(slack_response)
      subject.class.get(slack_method, limit, page)
      ENV["slack_bot_auth"] = cached_slack_token
    end

    it 'calls users.list with limit and next page request' do
      cached_slack_token = ENV["slack_bot_auth"]
      ENV["slack_bot_auth"] = "12345"
      page = 'cde45'
      allow(HTTParty).to receive(:get).
        with('https://slack.com/api/methods/users.list?token=12345&limit=100&cursor=cde45').
        and_return(slack_response)
      subject.class.get(slack_method, limit, page)
      ENV["slack_bot_auth"] = cached_slack_token
    end


    it 'calls usergroups.list with Slack API' do
      cached_slack_token = ENV["slack_bot_auth"]
      ENV["slack_bot_auth"] = "12345"
      slack_method = 'usergroups.list'
      allow(HTTParty).to receive(:get).
        with('https://slack.com/api/methods/usergroups.list?token=12345&limit=100').
        and_return(slack_response)
      subject.class.get(slack_method, limit, page)
      ENV["slack_bot_auth"] = cached_slack_token
    end
  end
end