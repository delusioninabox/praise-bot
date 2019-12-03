RSpec.describe PraiseMessage do
  context "when valid values" do
    let(:values) {
      {
        "headline-block": {
          "headline": {
            "value": "A new headline!"
          }
        },
        "details-block": {
          "details": {
            "value": "Here is why they're great..."
          }
        }
      }.as_json
    }
    let(:user) {
      {
        "id": "USER123",
        "username": "Carol"
      }.as_json
    }
    let(:view) { FactoryBot.create(:view, :valid_fields) }
    it("calls to submit message") do
      new_view = view
      new_view.headline = "A new headline!"
      new_view.details = "Here is why they're great..."
      expect(PraiseBot).to receive(:submit).with(
        [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": ":tada: *A new headline!* :tada:\n<@USER15>, <@USER20>"
            }
          },
          {
            "type": "divider"
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": ":muscle: Courage"
                  }
          },
          {
            "type": "divider"
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "Here is why they're great..."
                  }
          },
          {
            "type": "divider"
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "_Submitted by <@USER123>_"
            }
          }
        ],
        new_view
      ).once
      subject.class.build(values, view.view_id, user)
      check_view = View.find_by({view_id: view.view_id})
      expect(check_view.headline).to eq("A new headline!")
      expect(check_view.details).to eq("Here is why they're great...")
    end
  end

  context "when deleting a view" do
    # it is deleted
  end
end