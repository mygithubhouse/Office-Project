module BxBlockStatesCities
	class Zipcode < ApplicationRecord
		self.table_name = :zipcodes
		enum grid_type: {'ERCOT' =>0, 'SPP' =>1, 'MISO' =>2}
    	validates :code, uniqueness: { scope: :grid_type }
		belongs_to :city, class_name: 'BxBlockStatesCities::City'
	end
end
