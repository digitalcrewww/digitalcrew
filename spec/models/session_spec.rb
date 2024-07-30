require 'rails_helper'

RSpec.describe Session, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:session)).to be_valid
  end

  it 'is not valid without a user' do
    expect(build(:session, user: nil)).to_not be_valid
  end

  it 'is not valid without a session_id' do
    expect(build(:session, session_id: nil)).to_not be_valid
  end
end
