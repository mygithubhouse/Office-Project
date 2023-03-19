module BxBlockContactUs
  class PreviewVideoSerializer < BuilderBase::BaseSerializer
    attributes *[
        :description,
        :video_url,
        :image
    ]

    attribute :image do |object|
      image = get_image_url(object) ? get_image_url(object) : ""
      dynamic_image = BxBlockContactUs::PreviewVideo.find_by_image('image') if image == ""
      image = get_image_url(dynamic_image) unless dynamic_image.nil?
    end
  end
end
