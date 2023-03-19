FactoryBot.define do
  factory :car, :class => 'BxBlockCategories::Car' do
    car_name { "tesla" }
    electric_car_model { "test123" }
    maximum_km { "test123" }
    electric_car_year { "test123" }
    electric_car_make { "tesla" }
  end
end
