module BxBlockCustomAds
  class CustomAdSerializer < BuilderBase::BaseSerializer
      attributes *[
          :title,
          :start_date,
          :end_date,
          :status,
          :link,
          :message,
          :view_count,
          :click_count,
          :created_at,
          :updated_at,
      ]

    attribute :image do |object|
      host = Rails.application.routes.default_url_options[:host]
      if object.image.attached?
        host + Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true)
      else
        nil
      end
    end

    attribute :video do |object|
      host = Rails.application.routes.default_url_options[:host]
      if object.video.attached?
        host + Rails.application.routes.url_helpers.rails_blob_url(object.video, only_path: true)
      else
        nil
      end
    end

  end
end



