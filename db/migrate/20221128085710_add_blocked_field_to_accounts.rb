class AddBlockedFieldToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :blocked, :boolean, :default => false
    add_column :accounts, :sign_in_count, :integer, :default => 0
  end
end
