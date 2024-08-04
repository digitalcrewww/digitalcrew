require 'rails_helper'

RSpec.describe Route, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      route = build(:route)
      expect(route).to be_valid
    end

    it 'is not valid without a flight number' do
      route = build(:route, flight_number: nil)
      expect(route).to_not be_valid
    end

    it 'is not valid with a duplicate flight number' do
      create(:route, flight_number: 'VA123')
      route = build(:route, flight_number: 'VA123')
      expect(route).to_not be_valid
    end

    it 'is not valid without a departure ICAO' do
      route = build(:route, departure_icao: nil)
      expect(route).to_not be_valid
    end

    it 'is not valid without an arrival ICAO' do
      route = build(:route, arrival_icao: nil)
      expect(route).to_not be_valid
    end

    it 'is not valid without a duration' do
      route = build(:route, duration: nil)
      expect(route).to_not be_valid
    end

    it 'is not valid with a non-positive duration' do
      route = build(:route, duration: 0)
      expect(route).to_not be_valid
      route.duration = -1
      expect(route).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has and belongs to many fleets' do
      association = described_class.reflect_on_association(:fleets)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
  end

  describe 'scopes' do
    let!(:route1) { create(:route, departure_icao: 'KLAX', arrival_icao: 'KJFK') }
    let!(:route2) { create(:route, departure_icao: 'KLAX', arrival_icao: 'KBOS') }
    let!(:route3) { create(:route, departure_icao: 'KBOS', arrival_icao: 'KLAX') }

    describe '.by_departure' do
      it 'returns routes with the specified departure ICAO' do
        expect(Route.by_departure('KLAX')).to contain_exactly(route1, route2)
      end
    end

    describe '.by_arrival' do
      it 'returns routes with the specified arrival ICAO' do
        expect(Route.by_arrival('KLAX')).to contain_exactly(route3)
      end
    end
  end

  describe '#flight_time' do
    it 'returns the correct formatted flight time' do
      route = build(:route, duration: 510)
      expect(route.flight_time).to eq '08:30'
    end
  end
end
