require 'slack_connect'

class TeamMembers
  limit = 100

  def self.syncUsers(page)
    @data = SlackConnect.get('users.list', limit, page)

    @data.members.map { |item|
      user = User.where(slack_id: item.id).first_or_initialize
      user.assign_attributes({ display_name: item.name, actual_name: item.profile.real_name_normalized, is_group: false })
      return user
    }
    @data.members.save

    unless @data.response_metadata.next_cursor.empty?
      # if next_cursor (page) exists
      this.syncUsers(@data.response_metadata.next_cursor)
    end
  end

  def self.syncUserGroups(page)
    @data = SlackConnect.get('usergroups.list', limit, page)

    @data.usergroups.map { |item|
      user = User.where(slack_id: item.id).first_or_initialize
      user.assign_attributes({ display_name: item.name, actual_name: null, is_group: true })
      return user
    }

    @data.usergroups.save
    # user groups api does not have pagination (at this time)
  end
end