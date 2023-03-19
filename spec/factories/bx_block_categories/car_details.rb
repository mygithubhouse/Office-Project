FactoryBot.define do
  factory :car_details, :class => 'BxBlockCategories::CarDetail' do
	electric_car_make {["maruti", " hyundai", " mahindra", " renault"]}
	electric_car_model {["swift", " alto", " i20", " wagonor"]}
	electric_car_year {["2000", " 2001", " 2002", " 2003"]}    
  end
end

