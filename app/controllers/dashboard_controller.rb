class DashboardController < ApplicationController
  def index
    @user = current_user
    @airline = Setting.instance
  end
end
