class CreateCarYears < ActiveRecord::Migration[6.0]
  def change
    create_table :car_years do |t|
      t.string :year
      t.references :car_model, null: false, foreign_key: true

      t.timestamps
    end
  end
end
