module BxBlockNotifsettings
  class NotificationReminderSettingSerializer < BuilderBase::BaseSerializer
     attributes *[
                :first_reminder,
                :second_reminder,
                :morning_reminder,
                :active]

     attributes :first_reminder do |notification_reminder_setting|
     	format_time notification_reminder_setting.first_reminder
     end
     attributes :second_reminder do |notification_reminder_setting|
     	format_time notification_reminder_setting.second_reminder
     end

     attributes :morning_reminder do |notification_reminder_setting|
     	format_time notification_reminder_setting.morning_reminder
     end

        private

        def self.format_time(time)
            time.strftime("%I:%M %P") rescue ""
        end
    end
end

