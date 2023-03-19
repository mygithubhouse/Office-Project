module BxBlockCommunityforum
  class CommunityBlock < BxBlockCommunityforum::ApplicationRecord
    self.table_name = :community_blocks

    belongs_to :community_forum, class_name: 'BxBlockCommunityforum::CommunityForum', foreign_key: :community_forum_id
    belongs_to :account, class_name: 'AccountBlock::Account', foreign_key: :account_id

    validates :community_forum_id, uniqueness: { scope: :account_id }
  end
end
