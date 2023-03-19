class CreatePreviewVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :preview_videos do |t|
      t.text :description
      t.timestamps
    end
  end
end
