module BxBlockPosts
  class PostSerializer < BuilderBase::BaseSerializer

    attributes *[
        :id,
        :name,
        :body,
        :created_at
    ]

    attribute :comments do |object|
      object.comments.map(&:json_info)
    end

    attribute :created_at do |object|
      "#{time_ago_in_words(object.created_at)} ago"
    end

    attribute :comment_count do |object|
      object.comments.count
    end

    attribute :post_group do |object|
      object.group&.name
    end

    attribute :account_group do |object|
      object.account.experience_group
    end

    attribute :account_id do |object|
      object.account&.id
    end

    attribute :user_name do |object|
      object.account&.user_name
    end

    attribute :full_name do |object|
      object.account.name
    end
  end
end
