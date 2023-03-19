module BxBlockNotifications
  class NotificationsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    skip_before_action :validate_json_web_token, only: :send_notification
    before_action :current_user, except: :send_notification

    def index

      notifications = Notification.where('account_id = ?', current_user.id).order(created_at: :desc)
      unread_count = notifications.where(is_read: false).count
      if notifications.present?
        render json: NotificationSerializer.new(notifications, meta: {
            message: "List of notifications.", unread_count: unread_count}).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'No notification found.'},]}, status: :ok
      end
    end

    def show
      notification = Notification.find(params[:id])
      render json: NotificationSerializer.new(notification, meta: {
          message: "Success."}).serializable_hash, status: :ok
    end

    def create
      notification = Notification.new(notification_params)
      if notification.save
        render json: NotificationSerializer.new(notification, meta: {
            message: "Notification created."}).serializable_hash, status: :created
      else
        render json: {errors: format_activerecord_errors(notification.errors)},
               status: :unprocessable_entity
      end
    end

    def update
      notification = Notification.find(params[:id])
      if notification.update(is_read: true, read_at: DateTime.now)
        render json: NotificationSerializer.new(notification, meta: {
          message: "Notification marked as read."}).serializable_hash, status: :ok
      else
        render json: {errors: format_activerecord_errors(notification.errors)},
               status: :unprocessable_entity
      end
    end

    def destroy
      notification = Notification.find(params[:id])
      if notification.destroy
        render json: {message: "Deleted."}, status: :ok
      else
        render json: {errors: format_activerecord_errors(notification.errors)},
               status: :unprocessable_entity
      end
    end

    def send_notification
      return render json: { message: 'Param missing' }, status: 422 if param_missing?
      data = { title: 'windeverest', body: params[:message] }
      paylaod = { notification: data, data: data }
      if params[:datetime].present?
        job = BxBlockPushNotifications::SendFcmNotificationJob.perform_at(params[:datetime].to_datetime, params[:device_tokens], paylaod, true)
        render json: { message: "Job Scheduled" }, status: :ok
      else
        notification = BxBlockPushNotifications::SendFcmNotification.new.send_notification_with_token(params[:device_tokens], paylaod)
        if notification.success?
          render json: { message: notification.message }, status: :ok
        else
          render json: { error: notification.errors }, status: 422
        end
      end
    end

    private

    def param_missing?
      params[:message].blank? && params[:device_tokens].blank?
    end

    def notification_params
      params.require(:notification).permit(
        :headings, :contents, :app_url, :account_id
      ).merge(created_by: @current_user.id, account_id: @current_user.id)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
