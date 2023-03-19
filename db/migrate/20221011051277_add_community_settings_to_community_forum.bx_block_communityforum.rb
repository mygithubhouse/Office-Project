# This migration comes from bx_block_communityforum (originally 20210816110744)
# This migration comes from bx_block_communityforum (originally 20210623091118)
class AddCommunitySettingsToCommunityForum < ActiveRecord::Migration[6.0]
  def up
    add_column :community_forums, :post_request, :boolean, null: false, default: false
    add_column :community_forums, :join_request, :boolean, null: false, default: false
  end

  def down
    remove_column :community_forums, :post_request
    remove_column :community_forums, :join_request
  end
end
