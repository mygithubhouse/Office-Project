# This migration comes from bx_block_communityforum (originally 20210816110748)
# This migration comes from bx_block_communityforum (originally 20210806100424)
class AddContextToCommunityJoins < ActiveRecord::Migration[6.0]
  def change
    add_column :community_joins, :context, :string
  end
end
