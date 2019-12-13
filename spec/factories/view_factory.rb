FactoryBot.define do
  factory :view do
    slack_user_id { "USER12345" }
    view_id { "VIEW2019" }
    posted { false }

    trait :valid_fields do
      emoji  { "tada" }
      user_selection { ["<@USER15>", "<@USER20>"] }
      value_selection { [":muscle: Courage"] }
      headline { "Here is a headline!" }
      details { "Here is some text and details..." }
    end

    trait :invalid_value do
      value_selection { nil }
    end

    trait :invalid_user do
      user_selection { nil }
    end

    trait :invalid_emoji do
      emoji { "" }
    end

    trait :self_selected do
      user_selection { ["<@USER12345>", "<@USER20>"] }
    end

    trait :custom_value do
      custom_values { ":tada: energetic | :heart: helpful" }
    end

    trait :posted do
      posted { true }
    end
  end
end