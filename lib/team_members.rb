require 'slack_connect'

class TeamMembers
  limit = 100

  def self.syncUsers(page)
    data = SlackConnect.get('users.list', limit, page)
    # loop through data.members
    # id => slack_id
    # name => display_name
    # profile.real_name_normalized => actual_name
    # is_group = false
    # save users
    # data.response_metadata.next_cursor => page
    # if next_cursor is empty string, stop loop
    # if not empty, call syncUsers(next_cursor)
  end

  def self.syncUserGroups(page)
    data = SlackConnect.get('usergroups.list', limit, page)
    # loop through data.usergroups
    # id => slack_id
    # name => display_name
    # actual_name is null
    # is_group is true
    # save as user
    # data.response_metadata.next_cursor => page
    # if next_cursor is empty string, stop
    # if not empty, call syncUserGroups(next_cursor)
  end
end