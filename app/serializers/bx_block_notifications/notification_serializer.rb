module BxBlockNotifications
  class NotificationSerializer
    include FastJsonapi::ObjectSerializer
    attributes *[
        :id,
        :created_by,
        :headings,
        :contents,
        :app_url,
        :is_read,
        :read_at,
        :created_at
    ]

    attribute :read_at do |object|
      "#{time_ago_in_words(object.read_at)} ago" rescue nil
    end
  end
end

