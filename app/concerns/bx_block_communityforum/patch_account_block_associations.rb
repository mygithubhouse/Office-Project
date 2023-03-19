module BxBlockCommunityforum
  module PatchAccountBlockAssociations
    extend ActiveSupport::Concern

    included do
      has_many :my_communities, class_name: 'BxBlockCommunityforum::CommunityForum', dependent: :destroy
      has_many :joined_communities, foreign_key: :account_id,
      class_name: 'BxBlockCommunityforum::CommunityJoin', dependent: :destroy
      has_many :community_forums, -> (account) { where(status: 'regular') }, through: :joined_communities
    end

  end
end
