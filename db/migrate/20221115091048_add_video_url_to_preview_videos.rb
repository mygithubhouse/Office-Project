class AddVideoUrlToPreviewVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :preview_videos, :video_url, :string
  end
end
