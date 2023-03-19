class CreateCarDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :car_details do |t|
      t.string :electric_car_make, array: true
      t.string :electric_car_model, array: true
      t.string :electric_car_year, array: true
    end
  end
end

