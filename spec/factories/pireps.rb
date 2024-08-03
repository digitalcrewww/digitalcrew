FactoryBot.define do
  factory :pirep do
    association :user
    association :fleet
    association :multiplier
    sequence(:flight_number) { |n| "FL#{n}" }
    flight_date { Date.current }
    departure_icao { ['LFPG', 'EGLL', 'KJFK', 'RJTT'].sample }
    arrival_icao { ['LFPG', 'EGLL', 'KJFK', 'RJTT'].sample }
    flight_time_minutes { rand(30..360) }
    fuel_used { rand(500..5000) }
    cargo { rand(0..10000) }
    remarks { 'This is a test PIREP' }
    status { 'pending' }

    trait :with_long_flight do
      flight_time_minutes { rand(361..720) }
    end

    trait :with_heavy_cargo do
      cargo { rand(10001..50000) }
    end
  end
end
