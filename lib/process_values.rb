class ProcessValues
  def self.save(values, view)
    # Check has value & view
    if view.nil? || values.empty?
      return
    end

    # Loop through the values
    # Pull the field_name (action_id)
    # Then the value, based on type
    values.each_with_object({}) do |value_object, map|
      key = value_object[1].keys.first
      action = value_object[1][key]
      value = get_value(action)
      if value.present?
        field_name = key.to_s.gsub("-", "_").to_sym
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

  private

  def self.is_multi_select?(action)
    action[:type] == 'multi_static_select' && action[:selected_options].present?
  end

  def self.is_static_select?(action)
    action[:type] == 'static_select' && action[:selected_option].present?
  end

  def self.is_user_select?(action)
    action[:type] == 'multi_users_select' && action[:selected_users].present?
  end

  def self.is_external_select?(action)
    action[:type] == 'multi_external_select' && action[:selected_options].present?
  end

  def self.get_value(action)
    case
    when is_multi_select?(action)
      action[:selected_options].each_with_object([]) do |selection, array|
        array << selection[:value]
      end
    when is_static_select?(action)
      action[:selected_option][:value]
    when is_user_select?(action)
      action[:selected_users].each_with_object([]) do |user, array|
        array << "<@#{user}>"
      end
    when is_external_select?(action)
      action[:selected_options].each_with_object([]) do |user, array|
        array << "#{user[:value]}"
      end
    else # text input
      action[:value]
    end
  end
end