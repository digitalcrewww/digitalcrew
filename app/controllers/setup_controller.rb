class SetupController < ApplicationController
  before_action :redirect_if_setup_completed
  before_action :authenticate_user!, except: %i[new create]

  def new
    @user = User.new
    @setting = Setting.new
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)
      @user.save!

      @setting = Setting.new(setting_params)
      @setting.airline_owner = @user
      @setting.save!

      session_cookie = SessionManager.create_session(@user, request)
      cookies.signed[:session_id] = session_cookie
    end

    redirect_to root_path
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def setting_params
    params.require(:setting).permit(:airline_name, :callsign, :logo)
  end

  def redirect_if_setup_completed
    redirect_to root_path if Setting.exists?
  end
end
