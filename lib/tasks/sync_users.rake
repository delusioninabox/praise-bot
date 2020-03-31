namespace :sync_users do
  desc "Get users from Slack and sync to database"
  task get_users: :environment do
    # call TeamMembers.syncUsers(null)
  end

  desc "Get user groups from Slack and sync to database"
  task get_user_groups: :environment do
    # call TeamMembers.syncUserGroups(null)
  end

end
