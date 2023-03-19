module BxBlockCategories
  class CarModelSerializer < BuilderBase::BaseSerializer
    attributes *[
    :name,
    # :car_make_id
    ]
    attribute :car_year do |object|
      serializer = CarYearSerializer.new(
       object.car_years, { name: object.name }
      )
      serializer.serializable_hash[:data]
    end
  end
end
