module Admin
  class PilotsController < ApplicationController
    before_action :set_pilot, only: %i[update destroy]

    # TODO: Add admin verification
    def index
      @pilots = User.where(is_accepted: false)
    end

    def update
      @pilot.update(is_accepted: true)
      redirect_to admin_pilots_path
    end

    def destroy
      @pilot.destroy
      redirect_to admin_pilots_path
    end

    private

    def set_pilot
      @pilot = User.find(params[:id])
    end
  end
end
