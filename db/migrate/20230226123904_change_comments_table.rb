class ChangeCommentsTable < ActiveRecord::Migration[6.0]
  def up
    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id
    add_reference :comments, :post, index: true
    add_foreign_key :comments, :posts
  end

  def down
    add_column :comments, :commentable_id, :bigint
    add_column :comments, :commentable_type, :string
    remove_column :comments, :post_id
  end
end
