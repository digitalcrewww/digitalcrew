class SessionManager
  CACHE_EXPIRY = 2.weeks

  def self.create_session(user, request)
    session = user.sessions.create!(
      session_id: generate_secure_token,
      user_agent: request.user_agent
    )
    cache_user_session(session)
    { value: session.session_id, expires: CACHE_EXPIRY.from_now, httponly: true }
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create session: #{e.message}"
    nil
  end

  def self.destroy_session(session_id)
    Rails.cache.delete("user_session:#{session_id}")
    Session.find_by(session_id:)&.destroy
  end

  def self.fetch_user_from_session(session_id)
    Rails.cache.fetch("user_session:#{session_id}", expires_in: CACHE_EXPIRY) do
      session = Session.find_by(session_id:)
      session&.user
    end
  end

  def self.cache_user_session(session)
    Rails.cache.write("user_session:#{session.session_id}", session.user, expires_in: CACHE_EXPIRY)
  end

  def self.generate_secure_token
    SecureRandom.hex(32)
  end
end
