class CreateStates < ActiveRecord::Migration[6.0]
  def change
    create_table :states do |t|
      t.integer :country_list_id
      t.string :name
      t.string :alpha_code
      t.string :country_code
      
      t.timestamps
    end
  end
end
