RSpec.describe Api::PraiseController, type: :controller do

  describe '#create' do

    context "with trigger_id" do
      let(:params) { { "trigger_id": "1234" } }
      it 'calls to open modal' do
        expect(PraiseModal).to receive(:open).with(params[:trigger_id]).once
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
          "team_id": "teamABC123",
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

    context "with view_closed" do
      let(:params) { { "payload": '{
        "type": "view_closed",
        "user": {
          "id": "UA12345",
          "username": "bob"
        },
        "view": {
          "id": "1",
          "team_id": "teamABC123",
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
        "team_id": "teamABC123",
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
          "user-block": "You need to select at least one user to praise."
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
        "team_id": "teamABC123",
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
    it("returns a error") do
      post :create, :params => params
      expect(response.body).to eq(error_list.to_json)
    end
  end

  context "view_submission with plain text" do
    let(:params) { { "payload": '{
      "type": "view_submission",
      "user": {
        "id": "USER12345",
        "username": "Bob"
      },
      "view": {
        "id": "VIEW2019",
        "team_id": "teamABC123",
        "callback_id": "submit_praise",
        "state": {
          "values": {
            "image-url-block": {
              "image-url": {
                "value": "this is not an image url"
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
          "image-url-block": "Must be a URL for GIF, JPG or PNG image."
        }
      }
    }
    let!(:view) { FactoryBot.create(:view, :valid_fields) }
    it("returns a error") do
      post :create, :params => params
      expect(response.body).to eq(error_list.to_json)
    end
  end

  context "view_submission with wrong file type" do
    let(:params) { { "payload": '{
      "type": "view_submission",
      "user": {
        "id": "USER12345",
        "username": "Bob"
      },
      "view": {
        "id": "VIEW2019",
        "team_id": "teamABC123",
        "callback_id": "submit_praise",
        "state": {
          "values": {
            "image-url-block": {
              "image-url": {
                "value": "http://something.com/giphy.bmp"
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
          "image-url-block": "Must be a URL for GIF, JPG or PNG image."
        }
      }
    }
    let!(:view) { FactoryBot.create(:view, :valid_fields) }
    it("returns a error") do
      post :create, :params => params
      expect(response.body).to eq(error_list.to_json)
    end
  end
end