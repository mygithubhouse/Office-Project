ActiveAdmin.register BxBlockCategories::CarMake, as: 'Car Make' do
  menu label: "Car Make"
  config.filters = false
  permit_params :name

  show do
    attributes_table do
      row :name
   end
  end

  index do
    column :name
    actions
  end
   
  form do |f|
    f.inputs do
      input :name, placeholder: "Please Enter Make", required: true
    end
    f.actions
  end
   controller do
    def destroy
      @car_make = BxBlockCategories::CarMake.find_by(id: params[:id])
      return if @car_make.nil?
      
      begin
        if @car_make.destroy
          message = "Car make was successfully destroyed."
          redirect_to admin_car_makes_path, notice: message
        end
      rescue ActiveRecord::InvalidForeignKey
        message = "Record can't be deleted due to reference to car model"
        redirect_to admin_car_makes_path, notice: message
      end

    end
  end
end



