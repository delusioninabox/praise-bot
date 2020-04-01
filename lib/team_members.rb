require 'slack_connect'

class TeamMembers
  @@limit = 100

  def self.syncUsers(page)
    @data = SlackConnect.get('users.list', @@limit, page)

    if @data[:members].present? do
      @data[:members].map { |item|
        user = User.where(slack_id: item[:id]).first_or_initialize
        user.assign_attributes({
          display_name: item[:name],
          actual_name: item[:profile][:real_name_normalized],
          is_group: false,
          is_deleted: item[:deleted]
        })
        user.save
      }

      if @data[:response_metadata][:next_cursor].present?
        # if next_cursor (page) exists
        self.syncUsers(@data[:response_metadata][:next_cursor])
      end
    end
  end

  def self.syncUserGroups
    # user groups api does not have pagination (at this time)
    @data = SlackConnect.get('usergroups.list', @@limit, nil)

    if @data[:usergroups].present?
      @data[:usergroups].map { |item|
        user = User.where(slack_id: item[:id]).first_or_initialize
        user.assign_attributes({
          display_name: item[:handle],
          actual_name: item[:name],
          is_group: true
        })
        if item[:deleted_by].present?
          user.assign_attributes({ is_deleted: true })
        end
        user.save
      }
    end
  end
end