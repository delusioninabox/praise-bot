FactoryBot.define do
  factory :user do
    slack_id { "W012A3CDE" }
    display_name { "spengler" }
    actual_name { "Egon Spengler" }
    is_group { false }

    trait :is_group do
      slack_id { "S0614TZR7" }
      display_name { "admins" }
      actual_name { "Team Admins" }
      is_group { true }
    end
  end
end