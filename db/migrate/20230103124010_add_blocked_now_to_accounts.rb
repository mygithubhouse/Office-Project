class AddBlockedNowToAccounts < ActiveRecord::Migration[6.0]
  def change
	add_column :accounts, :blocked_now, :datetime
  end
end
