RSpec.describe TeamMembers do

  context '.syncUsers' do
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
            "deleted": false,
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
            "deleted": false,
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

    it 'retrieves and creates list of users' do
      first_response_body[:response_metadata][:next_cursor] = ""
      first_response = instance_double(HTTParty::Response, body: first_response_body.to_json)
      second_response = instance_double(HTTParty::Response, body: second_response_body.to_json)
      allow(HTTParty).to receive(:get).
        and_return(first_response, second_response)
      subject.class.syncUsers(nil)
      expect(User.all.count).to eq(2)
      expect(TeamMembers).not_to receive(:syncUsers)
    end

    it 'retrieves and updates existing users' do
      first_response_body[:response_metadata][:next_cursor] = ""
      first_response_body[:members][0][:name] = "jeff"
      FactoryBot.create(:user, slack_id: "W012A3CDE", display_name: "spengler", actual_name: "Egon Spengler")
      first_response = instance_double(HTTParty::Response, body: first_response_body.to_json)
      second_response = instance_double(HTTParty::Response, body: second_response_body.to_json)
      allow(HTTParty).to receive(:get).
        and_return(first_response, second_response)
      subject.class.syncUsers(nil)
      expect(User.all.count).to eq(2)
      expect(User.all.first[:display_name]).to eq("jeff")
      expect(TeamMembers).not_to receive(:syncUsers)
    end

    it 'requests next page if present' do
      first_response = instance_double(HTTParty::Response, body: first_response_body.to_json)
      second_response = instance_double(HTTParty::Response, body: second_response_body.to_json)
      allow(HTTParty).to receive(:get).
        and_return(first_response, second_response)
      subject.class.syncUsers(nil)
      expect(User.all.count).to eq(4)
    end
  end

  ##########################################################

  context '.syncUserGroups' do
    let(:group_response_body) {
      {
        "ok": true,
        "usergroups": [
            {
                "id": "S0614TZR7",
                "team_id": "T060RNRCH",
                "is_usergroup": true,
                "name": "Team Admins",
                "description": "A group of all Administrators on your team.",
                "handle": "admins",
                "is_external": false,
                "date_create": 1446598059,
                "date_update": 1446670362,
                "date_delete": 0,
                "auto_type": "admin",
                "created_by": "USLACKBOT",
                "updated_by": "U060RNRCZ",
                "prefs": {
                    "channels": [],
                    "groups": []
                },
                "user_count": "2"
            },
            {
                "id": "S06158AV7",
                "team_id": "T060RNRCH",
                "is_usergroup": true,
                "name": "Team Owners",
                "description": "A group of all Owners on your team.",
                "handle": "owners",
                "is_external": false,
                "date_create": 1446678371,
                "date_update": 1446678371,
                "date_delete": 0,
                "auto_type": "owner",
                "created_by": "USLACKBOT",
                "updated_by": "USLACKBOT",
                "prefs": {
                    "channels": [],
                    "groups": []
                },
                "user_count": "1"
            },
            {
                "id": "S0615G0KT",
                "team_id": "T060RNRCH",
                "is_usergroup": true,
                "name": "Marketing Team",
                "description": "Marketing gurus, PR experts and product advocates.",
                "handle": "marketing-team",
                "is_external": false,
                "date_create": 1446746793,
                "date_update": 1446747767,
                "date_delete": 1446748865,
                "created_by": "U060RNRCZ",
                "updated_by": "U060RNRCZ",
                "prefs": {
                    "channels": [],
                    "groups": []
                },
                "user_count": "0"
            }
        ]
    } }

    it 'retrieves and creates user groups as users' do
      group_response = instance_double(HTTParty::Response, body: group_response_body.to_json)
      allow(HTTParty).to receive(:get).
        and_return(group_response)
      subject.class.syncUserGroups
      expect(User.all.count).to eq(3)
    end

    it 'retrieves and updates existing user groups' do
      group_response_body[:usergroups][0][:handle] = "theboss"
      FactoryBot.create(:user, slack_id: "S0614TZR7", display_name: "admins", actual_name: "Team Admins")
      group_response = instance_double(HTTParty::Response, body: group_response_body.to_json)
      allow(HTTParty).to receive(:get).
        and_return(group_response)
      subject.class.syncUserGroups
      expect(User.all.count).to eq(3)
      expect(User.all.first[:display_name]).to eq("theboss")
    end
  end
end