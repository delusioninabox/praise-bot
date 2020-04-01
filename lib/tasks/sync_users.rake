namespace :sync_users do
  desc "Get users from Slack and sync to database"
  task get_users: :environment do
    TeamMembers.syncUsers(nil)
  end

  desc "Get user groups from Slack and sync to database"
  task get_user_groups: :environment do
    TeamMembers.syncUserGroups
  end

end
