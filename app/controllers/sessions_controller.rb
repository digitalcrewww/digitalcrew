class SessionsController < ApplicationController
  skip_authentication
  before_action :redirect_if_authenticated, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if valid_authentication?(user)
      handle_successful_authentication(user)
    else
      handle_failed_authentication
    end
  end

  def destroy
    SessionManager.destroy_session(cookies.signed[:session_id])
    cookies.delete(:session_id)
    redirect_to login_path
  end

  private

  def valid_authentication?(user)
    user&.authenticate(params[:password])
  end

  def handle_successful_authentication(user)
    if user.is_accepted?
      create_session_for(user)
      redirect_to root_path
    else
      render :new, status: :unauthorized
    end
  end

  def handle_failed_authentication
    render :new, status: :unprocessable_entity
  end

  def create_session_for(user)
    session_cookie = SessionManager.create_session(user, request)
    cookies.signed[:session_id] = session_cookie
  end
end
