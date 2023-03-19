module BxBlockGamification
  class UserBadgesSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer
    # only this attribute we will fetch in database
     attributes *[
        :badge_id,
        :unlocked,
    ]

  	attribute :name do |object|
      object.badge.name
    end

    attribute :title do |object|
      object.badge.title
    end

    attribute :description do |object|
      object.badge.description
    end

    attributes :image do |object, params|
       host = params[:host] || ''
       object.unlocked == true ? host + Rails.application.routes.url_helpers.rails_blob_url(object.badge.unlocked_image, only_path: true) : host + Rails.application.routes.url_helpers.rails_blob_url(object.badge.locked_image, only_path: true)
    end
  end
end