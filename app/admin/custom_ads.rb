ActiveAdmin.register BxBlockCustomAds::CustomAd, as:"Custom Ads" do
  menu label: "Custom Ads"
  permit_params :title, :start_date, :end_date, :status, :view_count, :click_count, :video, :image, :link, :message
  
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :title
      f.input :start_date, as: :date_time_picker, include_blank: false
      f.input :end_date, as: :date_time_picker, include_blank: false
      f.input :link
      f.input :message
      f.input :status
      f.input :image, as: :file, label: "Image", input_html: { accept: "image/*"  }, hint: "Image should be in '.jpg' format"
      f.input :video, as: :file, label: "Upload Video", input_html: { accept: "video/*" }, hint: "Video should be in '.mp4' format"
    end
    f.actions do
      if resource.persisted?
        f.action :submit, label: 'Update Custom Ad', class: 'action input_action'
      else
        f.action :submit, label: 'Create Custom Ad', class: 'action input_action'
      end
      f.action :cancel, as: :link, label: 'Cancel'
      end
  end


  index :title => "Custom Ads" do
    selectable_column
    id_column
    column :title
    column "start_date" 
    column "end_date"
    column "status" do |object|
      object.status ? "True" : "False"
    end
    column :link
    column :message
    column :view_count
    column :click_count
    actions
  end

  
  show do
    attributes_table do
      row :title
      row "start_date" 
      row "end_date" 
      row "status" do |object|
        object.status ? "True" : "False"
      end
      row :link
      row :message
      row :view_count
      row :click_count
      row :image do |ad|
        image_tag(url_for(ad.image), size: '100x100') if ad.image.attached?
      end
      row :video do |ad|
       video_tag url_for(ad.video),style: "width:50%;height:auto", controls: true if ad.video.attached?
      end
    end
  end
end