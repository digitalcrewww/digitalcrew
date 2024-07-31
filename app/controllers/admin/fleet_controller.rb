module Admin
  class FleetController < ApplicationController
    def index
      @fleet = Fleet.all
    end

    def create
      @fleet = Fleet.new(fleet_params)
      if @fleet.save
        redirect_to admin_fleet_index_path
      else
        @fleet = Fleet.all
        render :index
      end
    end

    private

    def fleet_params
      params.require(:fleet).permit(:aircraft_id, :livery)
    end
  end
end
