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
      }
    }
    let(:user) {
      {
        "id": "USER12345",
        "username": "Carol"
      }
    }
    let(:view) { FactoryBot.create(:view, :valid_fields) }
    it("calls to submit message") do
      new_view = view
      new_view.headline = "A new headline!"
      new_view.details = "Here is why they're great..."
      expect(PraiseBot).to receive(:submit).with(
        [
          {
            "type": "header",
            "text": {
              "type": "plain_text",
              "text": ":tada: A new headline! :tada:",
              "emoji": true
            }
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "<@USER15>, <@USER20>"
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
              "text": "_Submitted by <@USER12345>_"
            }
          }
        ],
        new_view
      ).once
      subject.class.build(values, view.view_id, view.team_id, user)
      check_view = View.find_by({view_id: view.view_id})
      expect(check_view.headline).to eq("A new headline!")
      expect(check_view.details).to eq("Here is why they're great...")
    end

    context "and an image url" do
      let(:values) {
        {
          "image-url-block": {
            "image-url": {
              "value": "https://media.giphy.com/media/sTczweWUTxLqg/giphy.gif"
            }
          }
        }
      }
      let(:user) {
        {
          "id": "USER12345",
          "username": "Carol"
        }
      }
      let(:view) { FactoryBot.create(:view, :valid_fields) }
      it("calls to submit message") do
        new_view = view
        new_view.image_url = "https://media.giphy.com/media/sTczweWUTxLqg/giphy.gif"
        expect(PraiseBot).to receive(:submit).with(
          [
            {
              "type": "header",
              "text": {
                "type": "plain_text",
                "text": ":tada: Here is a headline! :tada:",
                "emoji": true
              }
            },
            {
              "type": "section",
              "text": {
                "type": "mrkdwn",
                "text": "<@USER15>, <@USER20>"
              }
            },
            {
              "type": "image",
              "image_url": "https://media.giphy.com/media/sTczweWUTxLqg/giphy.gif",
              "alt_text": "An image has been attached to this kudos!"
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
                "text": "Here is some text and details..."
                    }
            },
            {
              "type": "divider"
            },
            {
              "type": "section",
              "text": {
                "type": "mrkdwn",
                "text": "_Submitted by <@USER12345>_"
              }
            }
          ],
          new_view
        ).once
        subject.class.build(values, view.view_id, view.team_id, user)
        check_view = View.find_by({view_id: view.view_id})
        expect(check_view.image_url).to eql("https://media.giphy.com/media/sTczweWUTxLqg/giphy.gif")
      end
    end

    context "when no values selected but has custom value" do
    let(:no_value_view) { FactoryBot.create(:view, :valid_fields, :invalid_value, :custom_value) }
      it "only shows custom values entered" do
        expect(PraiseBot).to receive(:submit).with(
          [
            {
              "type": "header",
              "text": {
                "type": "plain_text",
                "text": ":tada: A new headline! :tada:",
                "emoji": true
              }
            },
            {
              "type": "section",
              "text": {
                "type": "mrkdwn",
                "text": "<@USER15>, <@USER20>"
              }
            },
            {
              "type": "divider"
            },
            {
              "type": "section",
              "text": {
                "type": "mrkdwn",
                "text": ":tada: energetic | :heart: helpful"
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
                "text": "_Submitted by <@USER12345>_"
              }
            }
          ],
          no_value_view
        ).once
        subject.class.build(values, view.view_id, view.team_id, user)
      end
    end

  context "when no values selected and no custom value" do
    let(:no_value_view) { FactoryBot.create(:view, :valid_fields, :invalid_value) }
      it "skips displaying value section" do
        expect(PraiseBot).to receive(:submit).with(
          [
            {
              "type": "header",
              "text": {
                "type": "plain_text",
                "text": ":tada: A new headline! :tada:",
                "emoji": true
              }
            },
            {
              "type": "section",
              "text": {
                "type": "mrkdwn",
                "text": "<@USER15>, <@USER20>"
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
                "text": "_Submitted by <@USER12345>_"
              }
            }
          ],
          no_value_view
        ).once
        subject.class.build(values, view.view_id, view.team_id, user)
      end
    end
  end

  context "when deleting a view" do
    let!(:view) { FactoryBot.create(:view, :valid_fields) }
    it("it is deleted") do
      expect(View.all.count).to eq(1)
      subject.class.destroy(view.view_id)
      expect(View.all.count).to eq(0)
      expect(View.find_by({ view_id: view.view_id })).to eq(nil)
    end
  end
end