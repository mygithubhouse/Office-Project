class ChangeStateIdDataType < ActiveRecord::Migration[6.0]
  def change
    remove_column :cities, :state_id, :string
    add_column :cities, :state_id, :integer
  end
end
