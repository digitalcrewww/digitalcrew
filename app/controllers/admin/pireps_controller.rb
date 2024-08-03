module Admin
  class PirepsController < ApplicationController
    before_action :set_pirep, only: %i[show approve reject destroy]

    # TODO: Add admin verification
    def index
      @pireps = Pirep.all.group_by(&:status)
    end

    def show; end

    def approve
      @pirep.approve!
      redirect_to admin_pireps_path
    end

    def reject
      @pirep.reject!
      redirect_to admin_pireps_path
    end

    def destroy
      @pirep.destroy
      redirect_to admin_pireps_path
    end

    private

    def set_pirep
      @pirep = Pirep.find(params[:id])
    end
  end
end
