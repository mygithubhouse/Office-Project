class CreateRolePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :role_permissions do |t|
      t.integer :role_id
      t.integer :permission_id

      t.timestamps

    end
  end
end
