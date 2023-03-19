class ChangePostTable < ActiveRecord::Migration[6.0]
  def up
    remove_column :posts, :description
    remove_column :posts, :location
    remove_column :posts, :category_id
    remove_column :posts, :account_id
    add_reference :posts, :account, index: true
    add_foreign_key :posts, :accounts
    add_reference :posts, :group, index: true
    add_foreign_key :posts, :groups
  end

  def down
    add_column :posts, :description, :string
    add_column :posts, :location, :string
    add_column :posts, :category_id, :integer
    remove_column :posts, :group_id
  end
end
