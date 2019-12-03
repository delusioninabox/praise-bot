RSpec.describe SlackActions do
  context "if no existing view" do
    let(:actions) {
      [
        {
          "action_id": "emoji",
          "block_id": "emoji_block",
          "type": "static_select",
          "selected_option": {
            "value": "heart"
          }
        }
      ].as_json
    }
    let(:user) {
      {
        id: "USER2",
        username: "Maria"
      }.as_json
    }
    it("creates a new view entry") do
      expect(View.all.count).to eq(0)
      subject.class.save(actions, "VIEW1", user)
      expect(View.all.count).to eq(1)
      new_view = View.last
      expect(new_view.emoji).to eq("heart")
      expect(new_view.view_id).to eq("VIEW1")
      expect(new_view.slack_user_id).to eq("USER2")
    end
  end

  context "sending multi user select" do
    let(:actions) {
      [
        {
          "action_id": "user_selection",
          "block_id": "user_block",
          "type": "multi_users_select",
          "selected_users": [
            "UA2222",
            "UA3333"
          ]
        }
      ].as_json
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves an array of users") do
      subject.class.save(actions, view.view_id, "USER12345")
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.user_selection).to eq(["<@UA2222>", "<@UA3333>"])
    end
  end

  context "sending static select" do
    let(:actions) {
      [
        {
          "action_id": "emoji",
          "block_id": "emoji_block",
          "type": "static_select",
          "selected_option": {
            "value": "heart"
          }
        }
      ].as_json
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves the single select value") do
      subject.class.save(actions, view.view_id, "USER12345")
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.emoji).to eq("heart")
    end
  end

  context "sending multi select" do
    let(:actions) {
      [
        {
          "action_id": "value_selection",
          "block_id": "values_block",
          "type": "multi_static_select",
          "selected_options": [
            { "value": ":heart: Empathy" },
            { "value": ":muscle: Courage" }
          ]
        }
      ].as_json
    }
    let(:view) { FactoryBot.create(:view) }
    it("saves the multiple select values") do
      subject.class.save(actions, view.view_id, "USER12345")
      updated_view = View.find_by({ view_id: view.view_id })
      expect(updated_view.value_selection).to eq([":heart: Empathy", ":muscle: Courage"])
    end
  end
end