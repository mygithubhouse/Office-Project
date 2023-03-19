module BxBlockCategories
  class CarModelsController < ApplicationController
  	skip_before_action :validate_json_web_token

    def index
      if params[:car_make_id].present?
        car_models = CarModel.all.where(car_make_id: params[:car_make_id])
        render json: CarModelSerializer.new(car_models).serializable_hash,status: 200
      else
        render json: { errors: 'Please select Electric Car Make' }, status: 404
      end
    end
  end
end