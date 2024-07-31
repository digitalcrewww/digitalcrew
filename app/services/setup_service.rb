class SetupService
  def initialize(user_params, setting_params)
    @user_params = user_params
    @setting_params = setting_params
  end

  def perform
    ActiveRecord::Base.transaction do
      create_user
      create_setting
      seed_aircraft
      mark_setup_as_completed
      true
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  attr_reader :user

  private

  def create_user
    @user = User.create!(@user_params.merge(is_accepted: true))
  end

  def create_setting
    @setting = Setting.create!(@setting_params.merge(airline_owner: @user))
  end

  def seed_aircraft
    AircraftSeederService.seed
  end

  def mark_setup_as_completed
    SetupStatusService.mark_as_completed
  end
end
