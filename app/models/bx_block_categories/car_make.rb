module BxBlockCategories
  class CarMake < BxBlockCategories::ApplicationRecord
    self.table_name = :car_makes
    has_many :car_models ,dependent: :destroy
    validates :name, presence: true
  end
end
