module Pilot
  class PirepsController < ApplicationController
    before_action :set_pirep_resources, only: %i[index create]

    def index
      @pirep = Pirep.new
    end

    def create
      @pirep = current_user.pireps.build(pirep_params)

      if @pirep.save
        redirect_to pireps_path
      else
        render :index
      end
    end

    private

    def set_pirep_resources
      @fleets = Fleet.all
      @multipliers = Multiplier.all
    end

    def pirep_params
      params.require(:pirep).permit(
        :flight_number, :flight_date, :departure_icao, :arrival_icao,
        :fuel_used, :cargo, :fleet_id, :multiplier_id, :flight_hours,
        :flight_minutes, :remarks, :status
      )
    end
  end
end
