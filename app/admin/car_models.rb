ActiveAdmin.register BxBlockCategories::CarModel, as: 'Car Models' do
  menu label: "Car Models"
  config.filters = false
  permit_params :name, :car_make_id

  show do
    attributes_table do
      row "Car Makes" do |m|
        if m.car_make_id.present?
          usr = BxBlockCategories::CarMake.find(m.car_make_id).name
        end
      end
      row :name
   end
  end

  index do
    column "Car Makes" do |m|
      if m.car_make_id.present?
        usr = BxBlockCategories::CarMake.find(m.car_make_id).name
      end
    end
    column :name
    actions
  end
   
  form do |f|
    f.inputs do
      input :name, placeholder: "Please Enter Model Name", required: true
      f.input :car_make_id, prompt: "Please select Car Make", required: true, :input_html => {:style=>'width:78%'}, :as => :select, :collection => BxBlockCategories::CarMake.all.collect {|car_make| [car_make.name, car_make.id] }
    end
    f.actions
  end
  controller do
    def destroy
      @car_model = BxBlockCategories::CarModel.find_by(id: params[:id])
      return if @car_model.nil?
      
      begin
        if @car_model.destroy
          message = "Car model was successfully destroyed."
          redirect_to admin_car_models_path, notice: message
        end
      rescue ActiveRecord::InvalidForeignKey
        message = "Record can't be deleted due to reference to car year"
        redirect_to admin_car_models_path, notice: message
      end

    end
  end
end
