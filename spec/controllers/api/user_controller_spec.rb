RSpec.describe Api::UserController, type: :controller do

  describe '#index' do

    context "with no search queries" do
      let!(:users) { FactoryBot.create_list(:user, 3) }
      let!(:groups) { FactoryBot.create_list(:user, 2, :is_group) }
      it 'returns all' do
        post :create
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options].count).to eq(5)
      end

      it 'does not return deleted users' do
        FactoryBot.create(:user, :is_deleted)
        post :create
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options].count).to eq(5)
      end
    end

    context "when returning values" do
      let!(:user) { FactoryBot.create(:user, display_name: "afreddie", actual_name: "Frederick Allonsy Boi")}
      let!(:group) { FactoryBot.create(:user, :is_group, display_name: "ballbots", actual_name: "The Bot Crew")}
      it 'returns users as <@ID> and teams as <!subteam^ID>' do
        post :create
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options][0][:value]).to eq("<@#{user.slack_id}>")
        expect(body[:options][1][:value]).to eq("<!subteam^#{group.slack_id}>")
      end
    end

    context "when returning all users" do
      let!(:match_user) { FactoryBot.create(:user, display_name: "defg", actual_name: "Dog Energy For Good")}
      let!(:match_group) { FactoryBot.create(:user, display_name: "abc", actual_name: "Your ABCs")}
      it 'returns alphabetical order' do
        post :create
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options][0][:text][:text]).to eq("abc (Your ABCs)")
        expect(body[:options][1][:text][:text]).to eq("defg (Dog Energy For Good)")
      end
    end

    context "with search queries" do
      let!(:users) { FactoryBot.create_list(:user, 3) }
      let!(:match_user) { FactoryBot.create(:user, display_name: "freddie", actual_name: "Frederick Allllllonsy Boi")}
      let!(:groups) { FactoryBot.create_list(:user, 2, :is_group) }
      let!(:match_group) { FactoryBot.create(:user, display_name: "allllllbots", actual_name: "The Bot Crew")}

      it 'returns match in display name' do
        params = { payload: { value: "bots" }.to_json }
        post :create, :params => params
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options].count).to eq(1)
      end

      it 'returns match in actual name' do
        params = { payload: { value: "Bot Crew" }.to_json }
        post :create, :params => params
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options].count).to eq(1)
      end

      it 'returns matches in either display or actual' do
        params = { payload: { value: "allllll" }.to_json }
        post :create, :params => params
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options].count).to eq(2)
      end

      it 'does not return deleted users' do
        FactoryBot.create(:user, :is_deleted, display_name: "thebots")
        params = { payload: { value: "bots" }.to_json }
        post :create, :params => params
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options].count).to eq(1)
      end

      it 'is case in-sensitive' do
        params = { payload: { value: "BOT CREW" }.to_json }
        post :create, :params => params
        body = JSON.parse(response.body,:symbolize_names => true)
        expect(body[:options].count).to eq(1)
      end
    end

  end

end