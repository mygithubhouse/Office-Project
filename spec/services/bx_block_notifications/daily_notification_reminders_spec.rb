require 'rails_helper'
RSpec.describe BxBlockNotifications::DailyNotificationReminders, type: :services do

  context '#Call' do
    before do
      @account = create(:account, device_token: "eyJhbGciOiJIUzUxMiJ9")
      @notification_reminder_setting = create(:notification_reminder_setting, account: @account)
      described_class.new([@account.device_token]).call
      @notification = BxBlockNotifications::Notification.all.last
    end

    it "notification match" do
      expect(@notification.present?).to be true
    end

    it "notification title match" do
      expect(@notification.headings).to match("windeverest")
    end

    it "notification account match" do
      expect(@notification.account_id).to be @account.id
      expect(@notification.is_read).to be false
    end

    it "notification first_reminder notification message match" do
      expect(@notification.contents).to match("Your car could contribute to a greener grid. Indicate your choice for tonight, either to 'decline' a charge, or to add a certain percent to your car's battery.")
    end
  end
end