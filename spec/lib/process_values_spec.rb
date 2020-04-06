RSpec.describe ProcessValues do
  context "sending multi user select" do
    let(:actions) {
      {
        "user-block": {
          "user-selection": {
            "type": "multi_external_select",
            "selected_options": [
              "UA2222",
              "UA3333"
            ]
          }
        }
      }.as_json
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves an array of users") do
      subject.class.save(actions, view)
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.user_selection).to eq(["<@UA2222>", "<@UA3333>"])
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
      }.as_json
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
      }.as_json
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
      }.as_json
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves the text value") do
      subject.class.save(actions, view)
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.headline).to eq("New Headline")
    end
  end
end