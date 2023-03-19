class AddChoiceFieldToAccounts < ActiveRecord::Migration[6.0]
  def change
      add_column :accounts, :question_choice_type, :integer
  end
end
