FactoryBot.define do
  factory :user do
    slack_id { "W012A3CDE" }
    display_name { "spengler" }
    actual_name { "Egon Spengler" }
    is_group { false }
  end
end