# This migration comes from bx_block_notifsettings (originally 20200928140431)
class CreateNotificationSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_settings do |t|
      t.string :title
      t.string :description
      t.integer :state

      t.timestamps
    end
  end
end
