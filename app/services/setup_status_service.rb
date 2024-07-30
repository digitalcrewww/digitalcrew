class SetupStatusService
  CACHE_KEY = 'app_setup_completed'.freeze
  CACHE_DURATION = 1.year

  def self.completed?
    Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_DURATION) do
      Setting.exists?
    end
  end

  def self.mark_as_completed
    Rails.cache.write(CACHE_KEY, true, expires_in: CACHE_DURATION)
  end
end
