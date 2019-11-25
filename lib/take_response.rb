class TakeResponse
  def self.format(values, user)
    puts "Received values: #{values}"
    # loop through values for each [:block_id] and then [:action_id]
    # (or just extract the block/action IDs since we know what they are)
    emoji = values[:emoji]
    headline = values[:headline]
    users_list = values[:users_list]
    values_list = values[:values_list]
    comments = values[:details]
    submitter = user[:id] # or user[:username]?

    divider = "/n--------------/n"
    message = ":rotating_light: *PRAISE ALERT!* :rotating_light:"
    message += divider
    message += ":#{emoji}: #{headline} :#{emoji}:"
    message += "/n #{users_list} /n"
    message += divider
    message += "#{values_list}"
    message += divider
    message += "#{comments}"
    message += divider
    message += "\n_Submitted by #{submitter}_"

    PraiseBot.submit(message)
  end
end