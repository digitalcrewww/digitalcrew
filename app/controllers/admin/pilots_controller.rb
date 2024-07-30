module Admin
  class PilotsController < ApplicationController
    # TODO: Add admin verification
    def index
      @pilots = User.where(is_accepted: false)
    end

    def update
      @pilot = User.find(params[:id])
      @pilot.update(is_accepted: true)
      redirect_to admin_pilots_path
    end
  end
end
