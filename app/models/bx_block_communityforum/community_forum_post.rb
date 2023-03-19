module BxBlockCommunityforum
  class CommunityForumPost < BxBlockCommunityforum::ApplicationRecord
    self.table_name = :community_forum_posts

    belongs_to :community_forum, class_name: 'BxBlockCommunityforum::CommunityForum', dependent: :destroy
    belongs_to :post, class_name: 'BxBlockPosts::Post', dependent: :destroy
  end
end
