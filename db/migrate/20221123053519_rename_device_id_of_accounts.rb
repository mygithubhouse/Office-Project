class RenameDeviceIdOfAccounts < ActiveRecord::Migration[6.0]
  def change
    rename_column :accounts, :device_id, :device_token 
  end
end
