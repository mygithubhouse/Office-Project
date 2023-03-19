module BxBlockAddress
  class Address < ApplicationRecord
    self.table_name = :addresses

    belongs_to :addressble , polymorphic: true
    # reverse_geocoded_by :latitude, :longitude

    enum address_type: {"Home" => 0, "Work" => 1, "Other" => 2}


    validates :address, :city, :state_or_province, :zipcode, presence: true


    # after_validation :reverse_geocode

    before_create :add_address_type

    private

    def add_address_type
      self.address_type = "Home" unless address_type.present?
    end
  end
end
