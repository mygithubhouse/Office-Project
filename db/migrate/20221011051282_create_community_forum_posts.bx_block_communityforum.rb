# This migration comes from bx_block_communityforum (originally 20210816113626)
class CreateCommunityForumPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :community_forum_posts do |t|
      t.references :community_forum, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
    end
  end
end
