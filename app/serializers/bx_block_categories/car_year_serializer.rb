module BxBlockCategories
  class CarYearSerializer < BuilderBase::BaseSerializer
    attributes *[
    :year,
    # :car_model_id
    ]
  end
end
