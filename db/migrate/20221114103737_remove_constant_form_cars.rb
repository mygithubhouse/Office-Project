class RemoveConstantFormCars < ActiveRecord::Migration[6.0]
  def change
    change_column :cars, :account_id, :integer 
  end
end
