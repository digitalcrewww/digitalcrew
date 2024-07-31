FactoryBot.define do
  factory :aircraft do
    sequence(:name) { |n| "Aircraft#{n}" }
    sequence(:icao_code) { |n| "icao#{n}" }
  end
end
