# This migration comes from bx_block_communityforum (originally 20210816110745)
# This migration comes from bx_block_communityforum (originally 20210702043111)
class AddStatusToCommunityJoins < ActiveRecord::Migration[6.0]
  def change
    add_column :community_joins, :status, :integer, default: 0
  end
end
