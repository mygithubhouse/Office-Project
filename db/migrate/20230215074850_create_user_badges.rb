class CreateUserBadges < ActiveRecord::Migration[6.0]
  def change
    create_table :user_badges do |t|
      t.references :account, null: false, foreign_key: true
      t.references :badge, null: false, foreign_key: true
      t.boolean :unlocked, default:false

      t.timestamps
    end
  end
end
