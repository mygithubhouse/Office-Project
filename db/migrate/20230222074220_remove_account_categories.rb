class RemoveAccountCategories < ActiveRecord::Migration[6.0]
  def change
    drop_table :account_categories do |t|
      t.integer :account_id
      t.integer :category_id

      t.timestamps
    end
  end
end
