class AddQuestionsFieldToAccounts < ActiveRecord::Migration[6.0]
  def change
      add_column :accounts, :commute_distance, :string
      add_column :accounts, :preconditioning_type, :integer
      add_column :accounts, :comfort_level, :string
      add_column :accounts, :electric_vehicle_break, :string
      add_column :accounts, :other, :string
  end
end
