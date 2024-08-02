module Pilot
  class PirepsController < ApplicationController
    def index
      @pirep = Pirep.new
      @fleets = Fleet.all
      @multipliers = Multiplier.all
    end

    def create
      @pirep = current_user.pireps.new(pirep_params)
      if @pirep.save
        redirect_to pireps_path
      else
        @fleets = Fleet.all
        @multipliers = Multiplier.all
        render :index
      end
    end

    private

    def pirep_params
      params.require(:pirep).permit(:flight_number, :flight_date, :departure_icao, :arrival_icao,
                                    :fuel_used, :cargo, :fleet_id, :multiplier_id, :flight_hours, :flight_minutes)
    end
  end
end
