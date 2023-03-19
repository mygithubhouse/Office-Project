# This migration comes from bx_block_communityforum (originally 20210816110747)
# This migration comes from bx_block_communityforum (originally 20210802045747)
class AddStatusToCommunities < ActiveRecord::Migration[6.0]
  def change
    add_column :community_forums, :status, :integer, default: 0, null: false
  end
end
