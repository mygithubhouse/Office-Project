module BxBlockStatesCities
	class City < ApplicationRecord
		self.table_name = :cities
		belongs_to :state, class_name: 'BxBlockStatesCities::State'
		has_many :zipcodes, class_name: 'BxBlockStatesCities::Zipcode', dependent: :destroy
		before_save :add_state_code
		def add_state_code
			self.state_code = state.alpha_code
		end
	end
end
