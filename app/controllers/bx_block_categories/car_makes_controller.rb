module BxBlockCategories
  class CarMakesController < ApplicationController
    skip_before_action :validate_json_web_token

    def index
      response = []
      response_data = {}
      car_makes = CarMake.includes(:car_models)
      car_makes.each do |make|
        make_data = make.name
        response = {}
        make.car_models.each do |year|
            year_model = year.name
            year_data = year.car_years.pluck(:year).map(&:to_i)
          response["#{year_model}"] = year_data if year_data.any?
        end
      response_data["#{make_data}"]= [response] if response.keys.any?
      response = []
      end
        if car_makes.present?
          render json: { values: [response_data]}
        else
          render json: {errors: "not found"},status: 404
        end
    end
  end
end
