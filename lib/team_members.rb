require 'slack_connect'

class TeamMembers
  @@limit = 100

  def self.syncUsers(page)
    @data = SlackConnect.get('users.list', @@limit, page)
    @data = JSON.parse(@data,:symbolize_names => true)

    if @data[:members].present?
      @data[:members].map { |item|
        user = User.where(slack_id: item[:id]).first_or_initialize
        name = item[:profile][:display_name]
        if name.empty?
          name = item[:name]
        end
        user.assign_attributes({
          display_name: item[:profile][:display_name],
          actual_name: item[:profile][:real_name_normalized],
          is_group: false,
          is_deleted: item[:deleted]
        })
        user.save
      }

      next_page = @data[:response_metadata][:next_cursor]
      if next_page.present?
        # if next_cursor (page) exists
        self.syncUsers(next_page)
      end
    end
  end

  def self.syncUserGroups
    # user groups api does not have pagination (at this time)
    @data = SlackConnect.get('usergroups.list', @@limit, nil)
    @data = JSON.parse(@data,:symbolize_names => true)

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