require 'slack_connect'

class TeamMembers
  @@limit = 100

  def self.syncUsers(page)
    @data = SlackConnect.get('users.list', @@limit, page)

    @data[:members].map { |item|
      user = User.where(slack_id: item[:id]).first_or_initialize
      user.assign_attributes({ display_name: item[:name], actual_name: item[:profile][:real_name_normalized], is_group: false })
      user.save
    }

    if @data[:response_metadata][:next_cursor].present?
      # if next_cursor (page) exists
      self.syncUsers(@data[:response_metadata][:next_cursor])
    end
  end

  def self.syncUserGroups
    @data = SlackConnect.get('usergroups.list', @@limit, nil)

    @data[:usergroups].map { |item|
      user = User.where(slack_id: item[:id]).first_or_initialize
      user.assign_attributes({ display_name: item[:handle], actual_name: item[:name], is_group: true })
      user.save
    }
    # user groups api does not have pagination (at this time)
  end
end