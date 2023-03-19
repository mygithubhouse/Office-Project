class AddAccountIdToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :account_id, :integer, null: false, foreign_key: true
  end
end

