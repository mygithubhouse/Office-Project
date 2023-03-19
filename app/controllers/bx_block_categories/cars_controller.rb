module BxBlockCategories
  class CarsController < ApplicationController
    skip_before_action :validate_json_web_token

    def index
      car = Car.new(car_params)
      render json: CarSerializer.new(car, params: { account: @account }).serializable_hash
    end

    def show
      @car = Car.find(params[:id])
      render json: CarSerializer.new(car, params: { account: @account }).serializable_hash
    end

    def create
      car = Car.new(car_params)
      if car.save
        render json: CarSerializer.new(car, params: { account: @account }).serializable_hash
      else
        render json: { message: "car can't be saved", errors: car.errors }, status: 400
      end
    end

    def update
      car = Car.find(params[:id])
      if car.update(car_params)
        render json: CarSerializer.new(car, params: { account: @account }).serializable_hash
      else
        render json: { message: "car can't be updated", errors: car.errors }, status: 400
      end
    end

    def destroy
      car = Car.find(params[:id])
      car.destroy
      render json: { message: 'car deleted!' }
    end

    def car_params
      params.require(:car).permit(:car_name ,  :maximum_km, [:electric_car_model, :electric_car_year, :electric_car_make])
    end
  	
  	def dropdown_details
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

