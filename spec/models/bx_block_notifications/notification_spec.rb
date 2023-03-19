require 'rails_helper'
RSpec.describe BxBlockNotifications::Notification, type: :model do
  NOTIFICATION_CONTENT1 = "Testing notification 1"
  NOTIFICATION_CONTENT2 = "Testing notification 2"

  context "validations" do
    let(:notification) { create(:notification) }
    it 'create notification with account validation error' do
      begin
        notification = create(:notification, contents: NOTIFICATION_CONTENT1)
      rescue Exception => e
        expect(e.message).to eq("Validation failed: Account must exist")
      end
    end

    let(:account) { create(:account)}
    it 'create notification with success' do
        notification = create(:notification, contents: NOTIFICATION_CONTENT1, account_id: account.id)
        expect(notification.contents).to eq(NOTIFICATION_CONTENT1)
    end

    it 'create notification with paylaod' do
      paylaod = { notification: {title: "windeverest", body: NOTIFICATION_CONTENT2}}
        accounts = AccountBlock::Account.where(id: account.id)
        notifications = BxBlockNotifications::Notification.save_push_notifications(accounts, nil, paylaod)
        notification = BxBlockNotifications::Notification.last
        expect(notification.contents).to eq(NOTIFICATION_CONTENT2)
    end

    
  end
end
