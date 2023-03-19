class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.string :car_name
      t.string :electric_car_model
      t.string :maximum_km
      t.string :electric_car_year
      t.string :electric_car_make
      t.timestamps
     end
  end
end
