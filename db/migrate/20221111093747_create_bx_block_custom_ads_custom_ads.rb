class CreateBxBlockCustomAdsCustomAds < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_ads do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :status, default:false
      t.integer :view_count, default: 0
      t.integer :click_count, default: 0

      t.timestamps
    end
  end
end
