module Admin
  class PirepsController < ApplicationController
    before_action :set_pirep, only: %i[show approve reject destroy]

    # TODO: Add admin verification
    def index
      @pireps = Pirep.all.group_by(&:status)
    end

    def show; end

    def approve
      update_status('approved')
    end

    def reject
      update_status('rejected')
    end

    def destroy
      @pirep.destroy
      redirect_to admin_pireps_path
    end

    private

    def set_pirep
      @pirep = Pirep.find(params[:id])
    end

    def update_status(new_status)
      @pirep.update(status: new_status)
      redirect_to admin_pireps_path
    end
  end
end
