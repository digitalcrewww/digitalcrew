class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[new create]
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session_cookie = SessionManager.create_session(user, request)
      cookies.signed[:session_id] = session_cookie
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    SessionManager.destroy_session(cookies.signed[:session_id])
    cookies.delete(:session_id)
    redirect_to root_path
  end
end
