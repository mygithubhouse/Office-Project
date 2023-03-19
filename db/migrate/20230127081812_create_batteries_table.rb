class CreateBatteriesTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :battery_percentage, :float
    create_table :battery_percentages do |t|
      t.belongs_to :account
      t.float :percent 
      t.string :grade
      t.integer :status
      t.timestamps
    end
  end
end

