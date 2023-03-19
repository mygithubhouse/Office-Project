FactoryBot.define do
  factory :broadcast, :class => 'BxBlockNotifications::Broadcast' do
    message { 'sample message for broadcast' }
    scheduled_date { 1.day.before }
    account_ids { [1,2,3] }
    factory :broadcast_with_enqued_job do
      after(:create) do |broadcast|
        scheduled = 1.day.after
        data = {title: "windeverest", body: 'sample message for broadcast'}
        paylaod = {notification: data, data: data}
        job = BxBlockPushNotifications::SendFcmNotificationJob.perform_at(scheduled, [1,2,3], paylaod)
        broadcast.update(jid: job, scheduled_date: scheduled)
      end
    end
  end
end
