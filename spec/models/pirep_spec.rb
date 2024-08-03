require 'rails_helper'

RSpec.describe Pirep, type: :model do
  let(:user) { create(:user) }
  let(:fleet) { create(:fleet) }
  let(:multiplier) { create(:multiplier) }

  it 'is valid with valid attributes' do
    pirep = Pirep.new(
      user: user,
      fleet: fleet,
      multiplier: multiplier,
      flight_number: 'FL123',
      flight_date: Date.current,
      departure_icao: 'LFPG',
      arrival_icao: 'EGLL',
      flight_time_minutes: 120,
      fuel_used: 5000,
      cargo: 1000,
      remarks: 'This is a test PIREP',
    )
    expect(pirep).to be_valid
  end

  it 'is not valid without a user' do
    pirep = Pirep.new(
      fleet: fleet,
      flight_number: 'FL123',
      flight_date: Date.current,
      departure_icao: 'LFPG',
      arrival_icao: 'EGLL',
      flight_time_minutes: 120,
      fuel_used: 5000,
      cargo: 1000,
      remarks: 'This is a test PIREP',
    )
    expect(pirep).to_not be_valid
  end

  it 'is not valid without a fleet' do
    pirep = Pirep.new(
      user: user,
      flight_number: 'FL123',
      flight_date: Date.current,
      departure_icao: 'LFPG',
      arrival_icao: 'EGLL',
      flight_time_minutes: 120,
      fuel_used: 5000,
      cargo: 1000,
      remarks: 'This is a test PIREP',
    )
    expect(pirep).to_not be_valid
  end

  it 'is valid without a multiplier' do
    pirep = Pirep.new(
      user: user,
      fleet: fleet,
      flight_number: 'FL123',
      flight_date: Date.current,
      departure_icao: 'LFPG',
      arrival_icao: 'EGLL',
      flight_time_minutes: 120,
      fuel_used: 5000,
      cargo: 1000,
      remarks: 'This is a test PIREP',
    )
    expect(pirep).to be_valid
  end

  it 'is not valid with a flight time less than 0' do
    pirep = Pirep.new(
      user: user,
      fleet: fleet,
      flight_number: 'FL123',
      flight_date: Date.current,
      departure_icao: 'LFPG',
      arrival_icao: 'EGLL',
      flight_time_minutes: -10,
      fuel_used: 5000,
      cargo: 1000,
      remarks: 'This is a test PIREP',
    )
    expect(pirep).to_not be_valid
  end

  it 'is not valid with invalid ICAO codes' do
    pirep = Pirep.new(
      user: user,
      fleet: fleet,
      flight_number: 'FL123',
      flight_date: Date.current,
      departure_icao: 'INVALID',
      arrival_icao: 'TOOLONG',
      flight_time_minutes: 120,
      fuel_used: 5000,
      cargo: 1000,
      remarks: 'This is a test PIREP',
    )
    expect(pirep).to_not be_valid
  end

  it 'converts flight time to HH:MM format' do
    pirep = Pirep.new(flight_time_minutes: 185)
    expect(pirep.flight_time).to eq('03:05')
  end
end
