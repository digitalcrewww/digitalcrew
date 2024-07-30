class SetupController < ApplicationController
  before_action :redirect_if_setup_completed
  before_action :authenticate_user!, except: %i[new create]

  def new
    @user = User.new
    @setting = Setting.new
  end

  def create
    service = SetupService.new(user_params, setting_params)

    if service.perform
      create_session(service.user)
      redirect_to root_path
    else
      @user = User.new(user_params)
      @setting = Setting.new(setting_params)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def create_session(user)
    session_cookie = SessionManager.create_session(user, request)
    cookies.signed[:session_id] = session_cookie
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def setting_params
    params.require(:setting).permit(:airline_name, :callsign, :logo)
  end

  def redirect_if_setup_completed
    redirect_to root_path if SetupStatusService.completed?
  end
end
