class CustomjsController < ApplicationController

  def send_notifications
    data = {title: "windeverest", body: params[:message]}
    paylaod = {notification: data, data: data}
    if params["datetime"].present?
      scheduled_date = params["datetime"].to_datetime
      job = BxBlockPushNotifications::SendFcmNotificationJob.perform_at(scheduled_date, params[:accounts_ids], paylaod)
      BxBlockNotifications::Broadcast.create(jid: job, account_ids: params[:accounts_ids], scheduled_date: scheduled_date, message: params[:message])
      render json: {message: "Notification It will send On #{scheduled_date}"}
    else
      notification = BxBlockPushNotifications::SendFcmNotification.new().send_notifications(params[:accounts_ids], paylaod)
      if notification.success?
        render json: {message: notification.message}, status: :ok
      else
        render json: {error: notification.errors}, status: :ok
      end
    end
  end
end
