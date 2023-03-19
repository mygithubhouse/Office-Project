class CreateZipcodes < ActiveRecord::Migration[6.0]
  def change
    create_table :zipcodes do |t|
    	t.string :code
    	t.integer :city_id
    	t.integer :grid_type
    	t.timestamps
    end
  end
end
