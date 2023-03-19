module BxBlockCategories
  class CarSerializer < BuilderBase::BaseSerializer
      attributes *[
      :electric_car_make,
      :electric_car_model,
      :electric_car_year,
      ]

  end
end
