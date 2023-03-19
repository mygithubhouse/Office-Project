FactoryBot.define do
  factory :notification_reminder_setting, :class => 'BxBlockNotifsettings::NotificationReminderSetting' do
    first_reminder {'07:00 AM'}
    second_reminder {'08:00 AM'}
    morning_reminder { '09:00 AM'}
    active { true }
    association :account
  end
end
