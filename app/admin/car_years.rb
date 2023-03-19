ActiveAdmin.register BxBlockCategories::CarYear, as: 'Car Years' do
 menu label: "Car Years"
 config.filters = false
  permit_params :year, :car_model_id

  show do
    attributes_table do
      row "Car Models" do |m|
        if m.car_model_id.present?
          usr = BxBlockCategories::CarModel.find(m.car_model_id).name
        end
      end
      row :year
   end
  end

  index do
    column "Car Makes" do |m|
      if m.car_model_id.present?
        usr = BxBlockCategories::CarModel.find(m.car_model_id).name
      end
    end
    column :year
    actions
  end
   
  form do |f|
    f.inputs do
      input :year, placeholder: "Please Enter Year", required: true
      f.input :car_model_id, required:true, :input_html => {:style=>'width:75%'}, :as => :select, :collection => BxBlockCategories::CarModel.all.collect {|car_model| [car_model.name, car_model.id] }
    end
    f.actions
  end  
end
