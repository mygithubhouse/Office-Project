module BxBlockCategories
  class CarMakeSerializer < BuilderBase::BaseSerializer
    attributes *[
    :name
    ]

    attribute :catalogue_variants do |object, params|
      serializer = CarModelSerializer.new(object.car_models).serializable_hash[:data]
    end
  end
end
