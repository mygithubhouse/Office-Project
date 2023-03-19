class AddBatteryPercentageAccounts < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :battery_percentage, :float
  end
end
