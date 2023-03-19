# This migration comes from bx_block_communityforum (originally 20210816110746)
# This migration comes from bx_block_communityforum (originally 20210702070439)
class CreateBxBlockCommunityforumCommunityBlock < ActiveRecord::Migration[6.0]
  def change
    create_table :community_blocks do |t|
      t.references :account, null: false, foreign_key: true
      t.references :community_forum, null: false, foreign_key: true

      t.index [:community_forum_id, :account_id], unique: true

      t.timestamps
    end
  end
end
