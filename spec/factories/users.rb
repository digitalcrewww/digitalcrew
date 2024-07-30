FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    is_accepted { true }

    trait :unaccepted do
      is_accepted { false }
    end
  end
end
