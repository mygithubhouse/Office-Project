module BxBlockPushNotifications
  class SendFcmNotificationJob
      include Sidekiq::Worker

      def perform(accounts_ids, paylaod, with_tokens = false)
        if with_tokens
          BxBlockPushNotifications::SendFcmNotification.new().send_notification_with_token(accounts_ids, paylaod)
        else
          BxBlockPushNotifications::SendFcmNotification.new().send_notifications(accounts_ids, paylaod)
        end
      end
    end
end
