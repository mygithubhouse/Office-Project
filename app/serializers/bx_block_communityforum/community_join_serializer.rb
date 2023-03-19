module BxBlockCommunityforum
  class CommunityJoinSerializer < BuilderBase::BaseSerializer
    attributes *[
    :account_id,
    :community_forum_id,
    :followed,
    :status,
    :created_at,
    :updated_at
    ]

    attribute :community_name do |object|
        object.community_forum.name
    end
  end
end
