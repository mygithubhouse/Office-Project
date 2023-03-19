FactoryBot.define do
  factory :notification, :class => 'BxBlockNotifications::Notification' do
    headings { 'windeverest' }
    contents { 'sample message for notification' }
    account_id { 1 }
  end
end
