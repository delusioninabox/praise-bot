class ProcessValues
  def self.save(values, view)
    # Check has value & view
    if view.nil? || values.empty?
      return
    end

    # Loop through the values
    # Pull the field_name (action_id)
    # Then the value, based on type
    values.each_with_object({}) do |object, map|
      key = object[1].keys.first
      field_name = key.gsub("-", "_").to_sym
      action = object[1][key]
      case
      when action['type'] == 'multi_static_select' && action['selected_options'].present?
        value = action['selected_options'].each_with_object([]) do |selection, array|
          array << selection['value']
        end
      when action['type'] == 'static_select' && action['selected_option'].present?
        value = action['selected_option']['value']
      when action['type'] == 'multi_users_select' && action['selected_users'].present?
        value = action['selected_users'].each_with_object([]) do |user, array|
          array << "<@#{user}>"
        end
      when action['type'] == 'multi_external_select' && action['selected_options'].present?
        value = action['selected_options'].each_with_object([]) do |user, array|
          array << "<@#{user['value']}>"
        end
      else # text input
        value = action['value']
      end
      if value.present?
        view.update_attributes({ field_name => value })
      end
    end

    if view.save
      Rails.logger.info("Values saved for view #{view.view_id}")
      Rails.logger.info("View: #{view.inspect}")
    else
      Rails.logger.info("Actions could not be saved for view #{view.view_id}")
    end

    # return updated View
    view
  end
end