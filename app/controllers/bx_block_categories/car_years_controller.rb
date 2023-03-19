module BxBlockCategories
  class CarYearsController < ApplicationController
    skip_before_action :validate_json_web_token

    def index
      if params[:car_model_id].present?
        car_years = CarYear.where(car_model_id: params[:car_model_id])
        render json: CarYearSerializer.new(car_years).serializable_hash,status: 200
      else
        render json: { errors: 'Please select Electric Car Model' }, status: 404
      end
    end
  end
end
