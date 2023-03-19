require 'rails_helper'
RSpec.describe BxBlockNotifications::Broadcast, type: :model do

  context "validations" do
    let(:broadcast) { create(:broadcast) }
    let(:broadcast2) { create(:broadcast_with_enqued_job) }
    context "with sidekiq job executed" do
      it "should validate for sidekiq job before deleting" do
        expect(broadcast).to be_valid
        expect(broadcast.destroy).to eq(false)
      end
    end
  end
end
