class SlackActions
  def self.save(actions, view_id, user)
    @view = View.find_by({ view_id: view_id })
    if @view.nil?
      @view = View.new({ view_id: view_id, slack_user_id: user['id'] })
    end

    actions.each_with_object({}) do |object, map|
      key = object['action_id'].to_sym
      case
      when object['type'] == 'multi_static_select'
        value = object['selected_options'].each_with_object([]) do |selection, array|
          array << selection['value']
        end
      when object['type'] == 'static_select'
        value = object['selected_option']['value']
      when object['type'] == 'multi_users_select'
        value = object['selected_users'].each_with_object([]) do |user, array|
          array << "<@#{user}>"
        end
      else
        value = object['value']
      end
      @view.update_attributes({ key => value })
    end

    if @view.save
      Rails.logger.info("Actions saved for view #{view_id}")
      Rails.logger.info("View: #{@view.inspect}")
    else
      Rails.logger.info("Actions could not be saved for view #{view_id}")
    end
  end
end