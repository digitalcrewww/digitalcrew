module Admin
  class FleetController < ApplicationController
    before_action :set_fleet, only: %i[update destroy]
    # TODO: Add admin verification
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

    def update
      if @fleet.update(fleet_params)
        render json: { livery: @fleet.livery }
      else
        render json: { errors: @fleet.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @fleet.destroy
      redirect_to admin_fleet_index_path
    end

    private

    def fleet_params
      params.require(:fleet).permit(:aircraft_id, :livery)
    end

    def set_fleet
      @fleet = Fleet.find(params[:id])
    end
  end
end
