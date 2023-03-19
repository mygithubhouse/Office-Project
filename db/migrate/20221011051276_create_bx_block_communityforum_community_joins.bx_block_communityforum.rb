# This migration comes from bx_block_communityforum (originally 20210816110743)
# This migration comes from bx_block_communityforum (originally 20210622095003)
class CreateBxBlockCommunityforumCommunityJoins < ActiveRecord::Migration[6.0]
  def change
    create_table :community_joins do |t|
      t.integer :community_forum_id
      t.integer :account_id
      t.boolean :followed, null: false, default: false

      t.index [:community_forum_id, :account_id], unique: true

      t.timestamps
    end
  end
end
