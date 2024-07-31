require 'rails_helper'

RSpec.describe Setting, type: :model do
  let(:user) { create(:user) }

  it 'is valid with valid attributes' do
    setting = Setting.new(
      airline_name: 'Test Airline',
      callsign: 'TEST',
      airline_owner: user
    )
    expect(setting).to be_valid
  end

  it 'is not valid without an airline name' do
    setting = Setting.new(callsign: 'TEST', airline_owner: user)
    expect(setting).to_not be_valid
  end

  it 'is not valid without a callsign' do
    setting = Setting.new(airline_name: 'Test Airline', airline_owner: user)
    expect(setting).to_not be_valid
  end

  it 'is not valid without an airline owner' do
    setting = Setting.new(airline_name: 'Test Airline', callsign: 'TEST')
    expect(setting).to_not be_valid
  end

  describe 'logo attachment' do
    it 'allows valid image formats' do
      setting = Setting.new(airline_name: 'Test Airline', callsign: 'TEST', airline_owner: user)

      %w[image/png image/jpeg image/gif].each do |mime_type|
        setting.logo.attach(io: Rails.root.join('spec/fixtures/files/logo.png').open,
                            filename: 'logo.png', content_type: mime_type)
        expect(setting).to be_valid
      end
    end

    it 'does not allow invalid image formats' do
      setting = Setting.new(airline_name: 'Test Airline', callsign: 'TEST', airline_owner: user)
      setting.logo.attach(io: Rails.root.join('spec/fixtures/files/test_file.txt').open,
                          filename: 'test_file.txt', content_type: 'text/plain')
      expect(setting).to_not be_valid
    end
  end

  describe '.instance' do
    it 'returns the first setting' do
      setting = Setting.create(airline_name: 'Test Airline', callsign: 'TEST', airline_owner: user)
      expect(Setting.instance).to eq(setting)
    end
  end
end
