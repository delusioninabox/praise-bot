RSpec.describe Api::PraiseController, type: :controller do

  describe '#create' do

    context "with trigger_id" do
      let(:params) { { "trigger_id": "1234" } }
      it 'calls to open modal' do
        expect(PraiseModal).to receive(:open).with(params[:trigger_id]).once
        post :create, :params => params
      end
    end

    context "with block_actions" do
      let(:params) { { "payload": '{
        "type": "block_actions",
        "user": {
          "id": "UA12345",
          "username": "bob"
        },
        "actions": [
          {
            "action_id": "selection",
            "block_id": "selection_block",
            "type": "static_select",
            "selected_option": {
              "value": "this one"
            }
          }
        ],
        "view": {
          "id": "1"
        }
      }' } }
      it 'calls to save block actions' do
        expect(SlackActions).to receive(:save).once
        post :create, :params => params
      end
    end

    context "with view_submission" do
      let(:params) { { "payload": '{
        "type": "view_submission",
        "user": {
          "id": "UA12345",
          "username": "bob"
        },
        "view": {
          "id": "1",
          "callback_id": "submit_praise",
          "state": {
            "values": [
              { "action_id": "test" }
            ]
          }
        }
      }' }}
      it 'calls to submit the praise' do
        expect(PraiseMessage).to receive(:build).once
        post :create, :params => params
      end
    end

    context "no view_closed" do
      let(:params) { { "payload": '{
        "type": "view_closed",
        "user": {
          "id": "UA12345",
          "username": "bob"
        },
        "view": {
          "id": "1",
          "callback_id": "submit_praise"
        }
      }' }}
      it 'calls to submit the praise' do
        expect(PraiseMessage).to receive(:destroy).once
        post :create, :params => params
      end
    end
  end

  context "view_submission with missing values" do
    let(:params) { { "payload": '{
      "type": "view_submission",
      "user": {
        "id": "USER12345",
        "username": "Bob"
      },
      "view": {
        "id": "VIEW2019",
        "callback_id": "submit_praise",
        "state": {
          "values": {
            "headline-block": {
              "headline": {
                "value": "A new headline!"
              }
            },
            "details-block": {
              "details": {
                "value": "Here is why they\'re great..."
              }
            }
          }
        }
      }
    }' }}
    let(:user) {
      {
        "id": "USER12345",
        "username": "Bob"
      }.as_json
    }
    let(:error_list) {
      {
        "response_action": "errors",
        "errors": {
          "emoji-block": "An emoji selection is required.",
          "user-block": "You need to select at least one user to praise.",
          "value-block": "You need to select at least one value."
        }
      }
    }
    let!(:view) { FactoryBot.create(:view) }
    it("returns a list of errors") do
      post :create, :params => params
      expect(response.body).to eq(error_list.to_json)
    end
  end

  context "view_submission with self selected" do
    let(:params) { { "payload": '{
      "type": "view_submission",
      "user": {
        "id": "USER12345",
        "username": "Bob"
      },
      "view": {
        "id": "VIEW2019",
        "callback_id": "submit_praise",
        "state": {
          "values": {
            "headline-block": {
              "headline": {
                "value": "A new headline!"
              }
            },
            "details-block": {
              "details": {
                "value": "Here is why they\'re great..."
              }
            }
          }
        }
      }
    }' }}
    let(:user) {
      {
        "id": "USER12345",
        "username": "Bob"
      }.as_json
    }
    let(:error_list) {
      {
        "response_action": "errors",
        "errors": {
          "user-block": "You can't praise yourself! :)"
        }
      }
    }
    let!(:view) { FactoryBot.create(:view, :valid_fields, :self_selected) }
    it("returns a list of errors") do
      post :create, :params => params
      expect(response.body).to eq(error_list.to_json)
    end
  end
end