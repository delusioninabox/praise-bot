FactoryBot.define do
  factory :user do
    slack_id { Faker::Alphanumeric.alpha(number: 10) }
    display_name { Faker::Twitter.screen_name }
    actual_name { Faker::Name.name }
    is_group { false }

    trait :is_group do
      slack_id { Faker::Alphanumeric.alpha(number: 10) }
      display_name { Faker::Twitter.screen_name }
      actual_name { Faker::Book.title }
      is_group { true }
    end
  end
end