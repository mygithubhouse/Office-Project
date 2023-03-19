# BxBlockCategories::CarMake.destroy_all
puts("Creating Car Dropdown Details")
car_models = [["swift", "Alto", "Waganor"], ["Creta", "Verna", "I20"],["City", "Amazr","Jazz" ], ["Polo", "Virtus", "Taigun" ]]
car_makes = ['Maruti Suzuki', 'Huyndai', 'Honda', 'Volkswagen']
car_years = [2010, 2015, 2018, 2020]
car_models.each_with_index do | model, index |
  car_make = BxBlockCategories::CarMake.find_or_create_by!(name: car_makes[index])
  model.each do |model_name|
    models = BxBlockCategories::CarModel.find_or_create_by!(name: model_name, car_make_id: car_make.id)
  end
  models = BxBlockCategories::CarModel.where(car_make_id: car_make.id)
  models.each do |model|
    car_years.each do |year|
      car_year = BxBlockCategories::CarYear.find_or_create_by!(year: year, car_model_id: model.id)
    end
  end
end