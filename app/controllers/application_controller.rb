class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  before_action :check_setup_status

  private

  def current_user
    @current_user ||= SessionManager.fetch_user_from_session(cookies.signed[:session_id])
  end

  def user_signed_in?
    !!current_user
  end

  def authenticate_user!
    redirect_to login_path unless user_signed_in?
  end

  def redirect_if_authenticated
    redirect_to root_path if user_signed_in?
  end

  def check_setup_status
    redirect_to setup_path unless SetupStatusService.completed? || controller_name == 'setup'
  end
end
