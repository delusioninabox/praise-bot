RSpec.describe TeamMembers do

  context '.syncUsers' do
    let(:first_response) { instance_double(HTTParty::Response, body: first_response_body) }
    let(:second_response) { instance_double(HTTParty::Response, body: second_response_body) }
    let(:first_response_body) {
      {
      "ok": true,
      "members": [
        {
            "id": "W012A3CDE",
            "team_id": "T012AB3C4",
            "name": "spengler",
            "deleted": false,
            "real_name": "spengler",
            "profile": {
                "avatar_hash": "ge3b51ca72de",
                "status_text": "Print is dead",
                "status_emoji": ":books:",
                "real_name": "Egon Spengler",
                "display_name": "spengler",
                "real_name_normalized": "Egon Spengler",
                "display_name_normalized": "spengler",
                "email": "spengler@ghostbusters.example.com",
                "team": "T012AB3C4"
            },
            "is_admin": true,
            "is_owner": false,
            "is_primary_owner": false,
            "is_restricted": false,
            "is_ultra_restricted": false,
            "is_bot": false,
            "updated": 1502138686,
            "is_app_user": false,
            "has_2fa": false
        },
        {
            "id": "W07QCRPA4",
            "team_id": "T0G9PQBBK",
            "name": "glinda",
            "profile": {
                "avatar_hash": "8fbdd10b41c6",
                "first_name": "Glinda",
                "last_name": "Southgood",
                "title": "Glinda the Good",
                "real_name": "Glinda Southgood",
                "real_name_normalized": "Glinda Southgood",
                "display_name": "Glinda the Fairly Good",
                "display_name_normalized": "Glinda the Fairly Good",
                "email": "glenda@south.oz.coven"
            },
            "is_admin": true,
            "is_owner": false,
            "is_primary_owner": false,
            "is_restricted": false,
            "is_ultra_restricted": false,
            "is_bot": false,
            "updated": 1480527098,
            "has_2fa": false
        }
    ],
    "cache_ts": 1498777272,
    "response_metadata": {
      "next_cursor": "dXNlcjpVMEc5V0ZYTlo="
    }
    } }
    let(:second_response_body) {
      {
      "ok": true,
      "members": [
        {
            "id": "AA27A3CDE",
            "team_id": "T012AB3C4",
            "name": "ajcrowley",
            "deleted": false,
            "real_name": "Anthony Crowley",
            "profile": {
                "real_name": "Anthony Crowley",
                "display_name": "ajcrowley",
                "real_name_normalized": "Anthony Crowley",
                "display_name_normalized": "ajcrowley",
                "team": "T012AB3C4"
            },
            "is_admin": true,
            "is_owner": false,
            "is_primary_owner": false,
            "is_restricted": false,
            "is_ultra_restricted": false,
            "is_bot": false,
            "updated": 1502138686,
            "is_app_user": false,
            "has_2fa": false
        },
        {
            "id": "889QCRPA4",
            "team_id": "T0G9PQBBK",
            "name": "angel",
            "profile": {
                "first_name": "Aziraphale",
                "last_name": "Heaven",
                "real_name": "Aziraphale Heaven",
                "real_name_normalized": "Aziraphale Heaven",
            },
            "is_admin": true,
            "is_owner": false,
            "is_primary_owner": false,
            "is_restricted": false,
            "is_ultra_restricted": false,
            "is_bot": false,
            "updated": 1480527098,
            "has_2fa": false
        }
    ],
    "cache_ts": 1498777272,
    "response_metadata": {
      "next_cursor": ""
    }
    } }

    before do
      allow(HTTParty).to receive(:get).
        and_return(first_response, second_response)
    end

    it 'retrieves and creates list of users' do
      first_response_body[:response_metadata][:next_cursor] = ""
      subject.class.syncUsers(nil)
      expect(User.all.count).to eq(2)
      expect(TeamMembers).not_to receive(:syncUsers)
    end

    it 'retrieves and updates existing users' do
      first_response_body[:response_metadata][:next_cursor] = ""
      FactoryBot.create(:user)
      subject.class.syncUsers(nil)
      expect(User.all.count).to eq(2)
      expect(TeamMembers).not_to receive(:syncUsers)
    end

    it 'requests next page if present' do
      subject.class.syncUsers(nil)
      expect(User.all.count).to eq(4)
    end
  end

  context '.syncUserGroups' do
    it 'retrieves and creates user groups as users' do
      # calls .get with correct values
      # creates users
    end

    it 'retrieves and updates existing user groups' do
    end
  end
end