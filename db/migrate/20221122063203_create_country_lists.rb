class CreateCountryLists < ActiveRecord::Migration[6.0]
  def change
    create_table :country_lists do |t|
      t.string :name
      t.string :alpha_code

      t.timestamps
    end
  end
end
