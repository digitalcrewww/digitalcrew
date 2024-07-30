FactoryBot.define do
  factory :setting do
    sequence(:airline_name) { |n| "Test Airline #{n}" }
    sequence(:callsign) { |n| "TST#{n}" }
    association :airline_owner, factory: :user
  end
end
