FactoryBot.define do
  factory :session do
    association :user
    session_id { SecureRandom.uuid }
    user_agent { 'Test User Agent' }
    expires_at { 2.weeks.from_now }
  end
end
