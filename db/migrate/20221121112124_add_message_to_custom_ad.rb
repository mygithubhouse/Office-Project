class AddMessageToCustomAd < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_ads, :message, :text
  end
end
