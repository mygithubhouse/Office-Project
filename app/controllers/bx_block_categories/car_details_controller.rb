module BxBlockCategories
  class CarDetailsController < ApplicationController
    skip_before_action :validate_json_web_token

    def index
      car_details = CarDetail.all
      if car_details.present? 
        render json: CarSerializer.new(car_details).serializable_hash,status: 200
      else
        render json: {errors: "not found"},status: 404
      end
    end
  
  end
end

