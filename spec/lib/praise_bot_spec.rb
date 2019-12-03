RSpec.describe PraiseBot do
  context '.submit' do
    let(:slack_url) { 'https://slack.com/api/chat.postMessage' }
    let(:slack_response) { instance_double(HTTParty::Response, body: slack_response_body) }
    let(:slack_response_body) { 'response_body' }
    let(:view) { FactoryBot.create(:view, :valid_fields) }
    let(:message) {
      [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": ":tada: *Kudos to you!!!* :tada:\n<@UA1111>, <@UA2222>"
          }
        },
        {
          "type": "divider"
        },
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": ":muscle: Courage | :heart: Empathy"
                }
        },
        {
          "type": "divider"
        },
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "This is an explanation of why they're cool."
                }
        },
        {
          "type": "divider"
        },
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "_Submitted by <@UA3333>_"
          }
        }
      ]
    }

    before do
      allow(HTTParty).to receive(:post).and_return(slack_response)
    end

    it 'calls chat.postMessage with Slack API' do
      subject.class.submit(message, view)
    end

    it 'updated the saved view to posted: true' do
      expect(view.posted).to eq(false)
      subject.class.submit(message, view)
      expect(view.posted).to eq(true)
    end

    it 'requires message block and view' do
      expect { subject.class.submit() }.to raise_error(ArgumentError)
      expect { subject.class.submit(message) }.to raise_error(ArgumentError)
      expect { subject.class.submit(view) }.to raise_error(ArgumentError)
    end
  end
end