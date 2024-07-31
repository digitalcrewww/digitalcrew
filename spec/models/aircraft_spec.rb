require 'rails_helper'

RSpec.describe Aircraft, type: :model do
  it 'is valid with valid attributes' do
    aircraft = Aircraft.new(name: 'Boeing 737', icao_code: 'B737')
    expect(aircraft).to be_valid
  end

  it 'is not valid without a name' do
    aircraft = Aircraft.new(icao_code: 'B737')
    expect(aircraft).to_not be_valid
  end

  it 'is not valid without an ICAO code' do
    aircraft = Aircraft.new(name: 'Boeing 737')
    expect(aircraft).to_not be_valid
  end
end
