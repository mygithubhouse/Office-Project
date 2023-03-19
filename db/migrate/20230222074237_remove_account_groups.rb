class RemoveAccountGroups < ActiveRecord::Migration[6.0]
  def change
    drop_table :account_groups_account_groups do |t|
      t.references :account, null: false, foreign_key: true
      t.references :account_groups_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
