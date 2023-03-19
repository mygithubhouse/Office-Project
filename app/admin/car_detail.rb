# ActiveAdmin.register BxBlockCategories::CarDetail, as: 'Car Details' do
# 	permit_params electric_car_make: [], electric_car_model: [], electric_car_year: []
# 	config.filters = false
# 	index do
# 		selectable_column
# 		column :electric_car_make
# 		column :electric_car_year
# 		column :electric_car_model
# 		actions
# 	end

# 	form do |f|
# 		f.inputs do
# 			car_make_placeholder = "Enter Electric Car Make Name: Tesla, Volvo, Nio, Nissan"
# 			car_year_placeholder = "Enter Electric Car Year: 2000, 2001, 2002, 2003"
# 			car_model_placeholder = "Enter Electric Car Moldel: Model s, AB Volvo, Juke"


# 			year_value = f.object.electric_car_make ? f.object.electric_car_year.to_csv.gsub("\n", "").gsub(",", ", ") : nil
# 			f.input :electric_car_year, multiple: true,  placeholder: car_year_placeholder, class: 'form-control', autofocus: true,input_html: {value: year_value}


# 			model_value = f.object.electric_car_make ? f.object.electric_car_model.to_csv.gsub("\n", "").gsub(",", ", ") : nil
# 			f.input :electric_car_model, multiple: true,  placeholder: car_model_placeholder, class: 'form-control', autofocus: true,input_html: {value: model_value}

# 			make_value = f.object.electric_car_make ? f.object.electric_car_make.to_csv.gsub("\n", "").gsub(",", ", ") : nil
# 			f.input :electric_car_make, multiple: true,  placeholder: car_make_placeholder, class: 'form-control', autofocus: true,input_html: {value: make_value}
# 		end
# 	f.actions
# 	end

# 	controller do
# 		def create
# 			car_params = params[:car_detail]
# 			if BxBlockCategories::CarDetail.count == 0
# 				BxBlockCategories::CarDetail.create(electric_car_model: car_params[:electric_car_model].split(','),
# 				   electric_car_year: car_params[:electric_car_year].split(','),
# 				   electric_car_make: car_params[:electric_car_make].split(',')) 
# 				flash[:success]
# 				redirect_to admin_car_details_path
# 			else
# 				flash[:error] = 'you can not create more than one record, please update the existing one'
# 				redirect_to admin_car_details_path
# 			end
# 		end

# 		def update
# 			car_params = params[:car_detail]
# 			if BxBlockCategories::CarDetail.update(electric_car_model: car_params[:electric_car_model].split(','),
# 				   electric_car_year: car_params[:electric_car_year].split(','),
# 				   electric_car_make: car_params[:electric_car_make].split(','))
# 			flash[:success]
# 			redirect_to admin_car_details_path
# 			end
# 		end

# 		def destroy
# 	      if BxBlockCategories::CarDetail.count == 1
# 	        flash[:error] = 'you can not delete record'
# 	        redirect_to admin_car_details_path
# 	      else
# 	        car_params = BxBlockCategories::CarDetail.find(params[:id])
# 	        car_params.destroy
# 	        flash[:success] = 'Deleted Successfully'
# 	        redirect_to admin_car_details_path
# 	      end
# 	    end
# 	end
	
# end