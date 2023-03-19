class BxBlockCustomAds::CustomAd < ApplicationRecord
    self.table_name = :custom_ads

    attr_accessor :timezone
    has_one_attached :image
    has_one_attached :video

    validate  :validate_image_content_type
    validate  :validate_video_content_type
    

  def set_timezone_customad    
    if self.timezone.present?
      offset = Time.now.in_time_zone(self.timezone).strftime("%:z")
      self.start_date = self.start_date.change(:offset => offset)
      self.end_date = self.end_date.change(:offset => offset)
    end      
  end

    private
     def validate_image_content_type
      if image.present? && !["image/jpeg", "image/jpg", "image/png"].include?(image.content_type)
        errors.add(:base, "Profile picture must be in jpg or png format")
      end
    end

    def validate_video_content_type
      if video.present? && !["video/mp4"].include?(video.content_type)
        errors.add(:base, "Video format must be in mp4")
      end
    end
end
