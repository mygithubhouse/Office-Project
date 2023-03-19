module BxBlockNotifsettings
  class NotificationReminderSettingsController < ApplicationController
    #before_action :get_noti_setting, only: [:show, :update, :destroy]

    def create
      notification_reminder_setting =  BxBlockNotifsettings::NotificationReminderSetting.new(notification_reminder_settings_params.merge(account_id: current_user.id))
      if notification_reminder_setting.save
        render json: ::BxBlockNotifsettings::NotificationReminderSettingSerializer.new(notification_reminder_setting).serializable_hash, status: :created
      else
        render json: { errors: format_activerecord_errors(notification_reminder_setting.errors) },
               status: :unprocessable_entity
      end
    end

    def index
      notification_reminder_setting = current_user.notification_reminder_setting
      render json: ::BxBlockNotifsettings::NotificationReminderSettingSerializer.new(notification_reminder_setting).serializable_hash, status: :ok
      
    end
    
    def notification_reminder_settings_params
      params.require(:data).require(:notification_reminder_settings).permit(:first_reminder, :second_reminder, :morning_reminder, :active)
    end
  end
end
