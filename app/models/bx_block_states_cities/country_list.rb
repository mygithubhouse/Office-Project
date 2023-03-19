# frozen_string_literal: true

module BxBlockStatesCities
  # This is countrylist model for show countries
  class CountryList < ApplicationRecord
    COUNTRY_LIST = {:CA=>"Canada", :US=>"United States"} 
    self.table_name = :country_lists
    has_many :states, class_name: 'BxBlockStatesCities::State', dependent: :destroy
  end
end
