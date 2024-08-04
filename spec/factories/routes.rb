FactoryBot.define do
  factory :route do
    sequence(:flight_number) { |n| "VA#{n}" }
    departure_icao { 'KLAX' }
    arrival_icao { 'KJFK' }
    duration { 240 }
  end
end
