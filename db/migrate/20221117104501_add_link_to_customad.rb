class AddLinkToCustomad < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_ads, :link, :string
  end
end
