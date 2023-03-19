require 'rails_helper'
RSpec.describe AccountBlock::BatteryPercentage, type: :model do
  let(:account) { create(:account) }
  it { is_expected.to belong_to(:account) }


  context "validations" do
    let(:battery_percentage) { build(:battery_percentage, account: account) }
    let(:battery_percentage1) { build(:battery_percentage, account: account) }
    it "should validate for one record per day" do
      expect(battery_percentage).to be_valid
      battery_percentage.save
      expect(battery_percentage1.valid?).to eq(false)
    end
  end
end
