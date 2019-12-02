require 'HTTParty'
require 'praise_modal'

RSpec.describe PraiseModal do
  context '.open' do
    let(:slack_url) { 'https://slack.com/api/views.open' }
    let(:slack_response) { instance_double(HTTParty::Response, body: slack_response_body) }
    let(:slack_response_body) { 'response_body' }

    before do
      allow(HTTParty).to receive(:post).and_return(slack_response)
    end

    it 'calls Slack API' do
      expect(HTTParty).to have_received(:post).with(slack_url)
    end
  end
end