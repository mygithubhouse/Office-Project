module BxBlockNotifsettings
  class NotificationSetting < BxBlockNotifsettings::ApplicationRecord
    include NotificationSettingsStates

    has_many :notification_groups,
             class_name: 'BxBlockNotifsettings::NotificationGroup',
             foreign_key: 'notification_setting_id',
             dependent: :destroy

    enum state: STATES

    self.table_name = :notification_settings
  end
end
