class AddLateChargeColumnToBatteryPercentage < ActiveRecord::Migration[6.0]
  def change
    add_column :battery_percentages, :late_charge, :boolean, default: false
  end
end
