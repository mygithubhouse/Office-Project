module BxBlockCategories
  class CarModel < BxBlockCategories::ApplicationRecord
    self.table_name = :car_models
    belongs_to :car_make
    has_many :car_years, dependent: :destroy
    validates :name, :car_make, presence: true
  end
end
