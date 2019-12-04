class ProcessValues
  def self.save(values, view)
    values.each_with_object({}) do |object, map|
      key = object[1].keys.first
      field_name = key.gsub("-", "_").to_sym
      action = object[1][key]
      case
      when action['type'] == 'multi_static_select'
        value = action['selected_options'].each_with_object([]) do |selection, array|
          array << selection['value']
        end
      when action['type'] == 'static_select'
        value = action['selected_option']['value']
      when action['type'] == 'multi_users_select'
        value = action['selected_users'].each_with_object([]) do |user, array|
          array << "<@#{user}>"
        end
      else
        value = action['value']
      end
      view.update_attributes({ field_name => value })
    end

    if view.save
      Rails.logger.info("Values saved for view #{view.view_id}")
      Rails.logger.info("View: #{view.inspect}")
    else
      Rails.logger.info("Actions could not be saved for view #{view.view_id}")
    end

    view
  end
end