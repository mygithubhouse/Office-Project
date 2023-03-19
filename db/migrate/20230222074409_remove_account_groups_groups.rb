class RemoveAccountGroupsGroups < ActiveRecord::Migration[6.0]
  def change
    drop_table :account_groups_groups do |t|
      t.string :name
      t.jsonb :settings
      t.timestamps
    end
  end
end
