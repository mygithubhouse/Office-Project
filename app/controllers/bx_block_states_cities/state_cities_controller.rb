# frozen_string_literal: true

module BxBlockStatesCities
  # This is stateCities class cities states countries and zipcode validation
  class StateCitiesController < ApplicationController
    before_action :check_city_params, only: :cities
    before_action :check_zipcode_params, only: :zipcode_validation

    def countries
      countries = { CA: 'Canada', US: 'United States' }
      render json: { countries: countries }, status: :ok
    end

    def cities
      cities_list = BxBlockStatesCities::City.includes(:state).where(states:
                                                                    { alpha_code: params[:alpha_code].upcase,
                                                                      country_code: params[:country_code].upcase })
      cities_response = prepare_response(cities_list)
      render json: { Cities: cities_response }, status: 200
    end

    def states
      if params[:country_code].present?
        states = BxBlockStatesCities::State.where(country_code: params[:country_code].upcase).order(:name)
        states_name = states.select(:alpha_code, :name, :country_code).as_json(except: 'id')
        render json: { states: states_name }, status: 200
      else
        render json: { errors: 'Please select Country code' }, status: 404
      end
    end

    def zipcode_validation
      if ValidatesZipcode.valid?(@zipcode, @country)
        render json: { message: 'This is Valid zipcode' }, status: 200
      else
        render json: { errors: 'This is invalid zipcode' }, status: 404
      end
    end

    def seed_cities
      BxBlockStatesCities::CreateCities.new.call
      render json: {message: 'updated successfully'}, status: 200
    end

    private

    def prepare_response(city_list)
      city_list.select(:state_code, :name).map do |x|
        Hash['name', x.name, 'state_code', x.state_code,
             'country_code', x.state.country_code]
      end
    end

    def check_city_params
      return unless params[:country_code].blank? || params[:alpha_code].blank?

      render json: { errors: 'Please select State code and Country code' },
             status: 404
    end

    def check_zipcode_params
      @zipcode = params[:zipcode]
      @country = params[:country].upcase.to_sym if params[:country].present?
      if CS.countries.exclude?(@country) || @country.blank?
        return render json: { message: [country: 'Value is not permitted'] },
                      status: 422
      end
      return render json: { message: [zipcode: 'Blank Value is not permitted'] }, status: 422 if @zipcode.blank?
    end
  end
end
