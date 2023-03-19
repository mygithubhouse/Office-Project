  module BxBlockNotification
  class ReminderNotificationWorker
    include Sidekiq::Worker

    def perform(*args)
      ::BxBlockNotifications::DailyNotificationReminders.new().call
    end

  end
end
