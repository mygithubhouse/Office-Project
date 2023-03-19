module BxBlockContactUs
  class PreviewVideo < BxBlockContactUs::ApplicationRecord
    validates :video_url, presence: true
    self.table_name = :preview_videos
    has_one_attached :image
      
  end
end
