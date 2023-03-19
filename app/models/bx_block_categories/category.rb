module BxBlockCategories
  class Category < BxBlockCategories::ApplicationRecord
    self.table_name = :categories

    validates :name, uniqueness: true, presence: true
    has_many :groups, class_name: "BxBlockAccountGroups::Group"
    accepts_nested_attributes_for :groups
  end
end
