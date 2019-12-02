RSpec.describe PraiseModal do
  context '.open' do
    let(:slack_url) { 'https://slack.com/api/views.open' }
    let(:slack_response) { instance_double(HTTParty::Response, body: slack_response_body) }
    let(:slack_response_body) { 'response_body' }

    before do
      allow(HTTParty).to receive(:post).and_return(slack_response)
    end

    it 'calls view.open with Slack API' do
      subject.class.open("12345")
    end
  end
end