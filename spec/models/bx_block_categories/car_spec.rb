require 'rails_helper'

RSpec.describe BxBlockCategories::Car, :type => :model do
 
  subject {BxBlockCategories::Car.new(car_name: "Alto", electric_car_model: "800", maximum_km: "123443", electric_car_year: "2012", electric_car_make: "maruti")}
    it { is_expected.to validate_presence_of(:car_name) }
    it { is_expected.to validate_presence_of(:electric_car_model) }
    it { is_expected.to validate_presence_of(:maximum_km) }
    it { is_expected.to validate_presence_of(:electric_car_year) }
    it { is_expected.to validate_presence_of(:electric_car_make) }
end

  

