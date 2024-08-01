module Admin
  class MultipliersController < ApplicationController
    before_action :set_multiplier, only: %i[update destroy]
    # TODO: Add admin verification

    def index
      @multipliers = Multiplier.all
    end

    def create
      @multiplier = Multiplier.new(multiplier_params)
      if @multiplier.save
        redirect_to admin_multipliers_path
      else
        @multipliers = Multiplier.all
        render :index
      end
    end

    def update
      if @multiplier.update(multiplier_params)
        render json: { value: @multiplier.value }
      else
        render json: { errors: @multiplier.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @multiplier.destroy
      redirect_to admin_multipliers_path
    end

    private

    def multiplier_params
      params.require(:multiplier).permit(:name, :value)
    end

    def set_multiplier
      @multiplier = Multiplier.find(params[:id])
    end
  end
end
