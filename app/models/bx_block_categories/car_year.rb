module BxBlockCategories
  class CarYear < BxBlockCategories::ApplicationRecord
    self.table_name = :car_years
    belongs_to :car_model
    validates :year,:car_model, presence: true
  end
end

