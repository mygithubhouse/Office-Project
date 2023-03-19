# frozen_string_literal: true

module BxBlockStatesCities
  # This is countrylist model for show countries
  class State < ApplicationRecord
    self.table_name = :states
    before_save :add_country_code
    belongs_to :country_list, class_name: 'BxBlockStatesCities::CountryList'
    has_many :cities, class_name: 'BxBlockStatesCities::City', dependent: :destroy

    def add_country_code
    	self.country_code = country_list.alpha_code
    end
  end
end
