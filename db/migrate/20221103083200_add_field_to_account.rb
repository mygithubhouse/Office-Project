class AddFieldToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :password_confirmation, :string
  end
end
