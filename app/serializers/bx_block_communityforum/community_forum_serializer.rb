module BxBlockCommunityforum
  class CommunityForumSerializer < BuilderBase::BaseSerializer
    attributes *[
        :id,
        :name,
        :description,
        :topics,
        :created_at,
        :updated_at
    ]

    attribute :admin do |object, params|
      object.admin?(params[:current_user]) if params.present?
    end

    attribute :join_request_sent do |object, params|
      object.join_requests.exists?(status: 'pending', account_id: params[:current_user].id) if params.present?
    end

    attribute :joined do |object, params|
      object.joined?(params[:current_user]) if params.present?
    end

    attribute :followed do |object, params|
      object.followed?(params[:current_user]) if params.present?
    end

    attribute :profile_pic do |object|
      BxBlockCommunityforum::CommunityForum.image_url(object.profile_pic)
    end

    attribute :cover_pic do |object|
      BxBlockCommunityforum::CommunityForum.image_url(object.cover_pic)
    end

    attribute :follower_count do |object|
      object.follower_count
    end
  end
end
