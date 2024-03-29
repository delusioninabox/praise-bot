RSpec.describe ProcessValues do
  context "sending multi external select" do
    let(:actions) {
      {
        "user-block": {
          "user-selection": {
            "type": "multi_external_select",
            "selected_options": [
              { "value": "<!subteam^UA2222>" },
              { "value": "<@UA3333>" }
            ]
          }
        }
      }
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves an array of users") do
      subject.class.save(actions, view)
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.user_selection).to eq(["<!subteam^UA2222>", "<@UA3333>"])
    end
  end

  context "sending static select" do
    let(:actions) {
      {
        "emoji-block": {
          "emoji": {
            "type": "static_select",
            "selected_option": {
              "value": "heart"
            }
          }
        }
      }
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves the single select value") do
      subject.class.save(actions, view)
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.emoji).to eq("heart")
    end
  end

  context "sending multi select" do
    let(:actions) {
      {
        "value-block": {
          "value-selection": {
            "type": "multi_static_select",
            "selected_options": [
              { "value": ":muscle: courage" },
              { "value": ":brain: creativity" }
            ]
          }
        }
      }
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves the multiple select values") do
      subject.class.save(actions, view)
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.value_selection).to eq([":muscle: courage", ":brain: creativity"])
    end
  end

  context "sending text input" do
    let(:actions) {
      {
        "headline-block": {
          "headline": {
            "type": "plain_text_input",
            "value": "New Headline"
          }
        }
      }
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves the text value") do
      subject.class.save(actions, view)
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.headline).to eq("New Headline")
    end
  end

  context "sending image url input" do
    let(:actions) {
      {
        "image-url-block": {
          "image-url": {
            "type": "plain_text_input",
            "value": "https://media.giphy.com/media/gw3IWyGkC0rsazTi/giphy.gif"
          }
        }
      }
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves the text value") do
      subject.class.save(actions, view)
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.image_url).to eq("https://media.giphy.com/media/gw3IWyGkC0rsazTi/giphy.gif")
    end
  end
end