class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  before_action :check_setup_status
  before_action :authenticate_user!
  before_action :ensure_user_accepted

  class << self
    def skip_authentication
      skip_before_action :authenticate_user!
      skip_before_action :ensure_user_accepted
    end
  end

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

  def ensure_user_accepted
    return unless user_signed_in? && !current_user.is_accepted?

    cookies.delete(:session_id)
    redirect_to login_path
  end

  def redirect_if_authenticated
    redirect_to root_path if user_signed_in? && current_user.is_accepted?
  end

  def check_setup_status
    redirect_to setup_path unless SetupStatusService.completed? || controller_name == 'setup'
  end
end
