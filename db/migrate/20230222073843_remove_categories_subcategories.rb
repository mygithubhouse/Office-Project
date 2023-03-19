class RemoveCategoriesSubcategories < ActiveRecord::Migration[6.0]
  def change
    drop_table :categories_sub_categories do |t|
      t.references :category, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true
    end
    BxBlockCategories::Category.delete_all
    BxBlockCategories::SubCategory.delete_all
  end
end
