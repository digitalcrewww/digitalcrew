require 'rails_helper'

RSpec.describe SessionManager do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }
  let(:request) { double('request', user_agent: 'Test User Agent') }

  describe '.create_session' do
    it 'creates a new session for the user' do
      expect do
        SessionManager.create_session(user, request)
      end.to change(Session, :count).by(1)
    end

    it 'returns a hash with session details' do
      result = SessionManager.create_session(user, request)
      expect(result).to be_a(Hash)
      expect(result).to have_key(:value)
      expect(result).to have_key(:expires)
      expect(result).to have_key(:httponly)
    end
  end

  describe '.fetch_user_from_session' do
    it 'returns the user for a valid session' do
      session = SessionManager.create_session(user, request)
      fetched_user = SessionManager.fetch_user_from_session(session[:value])
      expect(fetched_user).to eq(user)
    end

    it 'returns nil for an invalid session' do
      fetched_user = SessionManager.fetch_user_from_session('invalid_session_id')
      expect(fetched_user).to be_nil
    end
  end
end
