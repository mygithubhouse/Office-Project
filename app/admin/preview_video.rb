ActiveAdmin.register BxBlockContactUs::PreviewVideo, as: 'Preview Videos' do
  permit_params :description, :video_url, :image

  index do
    selectable_column
    column :description
    column :image do |ad|
      image_tag ad.image if ad.image.attached?
    end
    column :video_url
    actions
  end

  show do
    attributes_table do
      row :description
      row :image do |ad|
        image_tag ad.image if ad.image.attached?
      end
      row :video_url
    end
  end

  form do |f|
    f.inputs do
      input :description
      input :video_url
      input :image, as: :file
    end
    f.actions
  end

  controller do
    def create
      preview_params = params.require(:preview_video).permit(:description, :video_url, :image)
      if BxBlockContactUs::PreviewVideo.count == 0
        BxBlockContactUs::PreviewVideo.create(preview_params)
        redirect_to admin_preview_videos_path, notice: 'Preview videos was successfully created.'
      else
        redirect_to admin_preview_videos_path, notice: 'You can not create more than one record, please update the existing one'
      end
    end

    def destroy
      if BxBlockContactUs::PreviewVideo.count == 1
        redirect_to admin_preview_videos_path, notice: 'you can not delete record'
      else
        preview_params = BxBlockContactUs::PreviewVideo.find(params[:id])
        preview_params.destroy
        redirect_to admin_preview_videos_path, notice: 'Deleted Successfully'
      end
    end
  end
end
