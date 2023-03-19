class CreateNotificationReminderSetting < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_reminder_settings do |t|
      t.time :first_reminder
      t.time :second_reminder
      t.time :morning_reminder
      t.boolean :active, default: true

      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
