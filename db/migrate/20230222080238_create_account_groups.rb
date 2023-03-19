class CreateAccountGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts_groups do |t|
      t.belongs_to :account
      t.belongs_to :group
    end
  end
end
