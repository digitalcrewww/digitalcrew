FactoryBot.define do
  factory :fleet do
    aircraft
    sequence(:livery) { |n| "livery#{n}" }

    trait :with_specific_aircraft do
      transient do
        aircraft_name { 'Airbus A320' }
        aircraft_icao { 'A320' }
      end

      before(:create) do |fleet, evaluator|
        fleet.aircraft = create(:aircraft, name: evaluator.aircraft_name, icao_code: evaluator.aircraft_icao)
      end
    end
  end
end
