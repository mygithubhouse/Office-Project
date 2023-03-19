class AddIndexToTables < ActiveRecord::Migration[6.0]
  def change
  	BxBlockStatesCities::State.delete_all
	BxBlockStatesCities::City.delete_all
	BxBlockStatesCities::Zipcode.delete_all
  	add_index :states, [:country_code, :name], :unique => true
  	add_index :cities, [:state_code, :name], :unique => true
  	add_index :zipcodes, [:grid_type, :code], :unique => true
  end
end
