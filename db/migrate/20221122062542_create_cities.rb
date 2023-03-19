class CreateCities < ActiveRecord::Migration[6.0]
  def change
    create_table :cities do |t|
      t.string :state_id
      t.string :name
      t.string :state_code

      t.timestamps
    end
  end
end
