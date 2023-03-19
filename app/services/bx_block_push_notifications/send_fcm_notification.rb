module BxBlockPushNotifications
    class SendFcmNotification

      def send_notifications(accounts_ids, paylaod)
        begin
          accounts = AccountBlock::Account.where(id: accounts_ids)
          fcm_client = FCM.new(ENV['FCM_SEVER_KEY'])
          if accounts.present?
            ::BxBlockNotifications::Notification.save_push_notifications(accounts, nil, paylaod)
            registration_ids = accounts.pluck(:device_token)
            registration_ids.present? && registration_ids.map do |res|
              notification = fcm_client.send(res, paylaod)
            end
          end
            OpenStruct.new(success?: true, message: "Notifcation Successfully Seneded")
        rescue => e
            OpenStruct.new(success?: false, errors: e)
        end
      end

      def send_notification_with_token(device_tokens, paylaod)
        begin
          ::BxBlockNotifications::Notification.save_push_notifications(nil, device_tokens, paylaod)
          fcm_client = FCM.new(ENV['FCM_SEVER_KEY'])
          notification = fcm_client.send(device_tokens, paylaod)
          response = JSON.parse(notification[:body])
          if response['failure'] != 0
            OpenStruct.new(success?: false, errors: response['results'])
          else
            OpenStruct.new(success?: true, message: "Notifcation Successfully Seneded")
          end
        rescue Exception => e
          OpenStruct.new(success?: false, errors: e.message)
        end
      end
    end
end
