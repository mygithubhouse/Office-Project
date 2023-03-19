module BxBlockCategories
  class Car < BxBlockCategories::ApplicationRecord
    self.table_name = :cars
    belongs_to :account, class_name: "AccountBlock::Account",
      foreign_key: "account_id", optional: true
    validates :car_name, :electric_car_model, :maximum_km, :electric_car_year, :electric_car_make, presence: true
  end
end
