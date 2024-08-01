FactoryBot.define do
  factory :multiplier do
    sequence(:name) { |n| "Multiplier #{n}" }
    value { rand(1.0..3.0).round(1) }
  end
end
