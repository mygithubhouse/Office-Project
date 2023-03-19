module BxBlockNotifsettings
  class NotificationReminderSetting < BxBlockNotifsettings::ApplicationRecord

  	belongs_to :account, class_name: "AccountBlock::Account"

    self.table_name = :notification_reminder_settings
  end
end
