require 'rails_helper'

RSpec.describe Fleet, type: :model do
  it 'is valid with valid attributes' do
    Fleet.create(aircraft: create(:aircraft), livery: 'Test Livery')
    expect(Fleet.first).to be_valid
  end

  it 'is not valid without an aircraft' do
    fleet = Fleet.new(livery: 'Test Livery')
    expect(fleet).to_not be_valid
  end

  it 'is not valid without a livery' do
    fleet = Fleet.new(aircraft: create(:aircraft))
    expect(fleet).to_not be_valid
  end
end
