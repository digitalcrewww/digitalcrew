require 'rails_helper'

RSpec.describe Multiplier, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:multiplier)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:multiplier, name: nil)).to_not be_valid
  end

  it 'is not valid without a value' do
    expect(build(:multiplier, value: nil)).to_not be_valid
  end

  it 'is not valid with a value less than 1.0' do
    expect(build(:multiplier, value: 0.9)).to_not be_valid
  end
end
