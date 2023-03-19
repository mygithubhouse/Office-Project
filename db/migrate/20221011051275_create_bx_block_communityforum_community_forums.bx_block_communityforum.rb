# This migration comes from bx_block_communityforum (originally 20210816110742)
# This migration comes from bx_block_communityforum (originally 20210616132208)
class CreateBxBlockCommunityforumCommunityForums < ActiveRecord::Migration[6.0]
  def change
    create_table :community_forums do |t|
      t.string :name, null: false
      t.string :description
      t.string :topics
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
