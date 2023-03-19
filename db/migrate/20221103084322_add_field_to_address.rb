class AddFieldToAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :city, :string
    add_column :addresses, :state_or_province, :string
    add_column :addresses, :zipcode, :integer
  end
end
