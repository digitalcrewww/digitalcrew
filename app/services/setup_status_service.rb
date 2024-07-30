class SetupStatusService
  CACHE_KEY = 'app_setup_completed'.freeze

  def self.completed?
    Rails.cache.fetch(CACHE_KEY) do
      Setting.exists?
    end
  end

  def self.mark_as_completed
    Rails.cache.write(CACHE_KEY, true)
  end
end
