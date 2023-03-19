class CreateBadges < ActiveRecord::Migration[6.0]
  def change
    create_table :badges do |t|
      t.string :name
      t.text :title
      t.text :description

      t.timestamps
    end
  end
end
