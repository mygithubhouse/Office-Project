require 'rails_helper'
RSpec.describe AccountBlock::AssignBasicGroups do
  let(:account1) { create(:account) }
  let(:account2) { create(:account, created_at: 15.month.ago) }
  let(:address) { create(:address, zipcode: '77777', addressble: account2) }
  let(:no_tesla) { create(:car, electric_car_make: 'Huyndai', account: account2) }
  context "With Tesla, non existed zipcode and newly created account" do
    before do
      account1.groups.delete(account1.groups)
      subject.perform(account1.id)
    end
    it "assigns groups based on created_at field" do
      expect(account1.reload.groups.pluck(:name)).to match_array(['NewUser', 'Tesla', 'Offline', 'South'])
    end
  end
  context "With NonTesla, existed zipcode and old created account" do
    before do
      address
      account2.car.delete
      no_tesla
      account2.groups.delete(account2.groups)
      subject.perform(account2.id)
    end
    it "assigns groups based on created_at field" do
      expect(account2.reload.groups.pluck(:name)).to match_array(['Veteran', 'NonTesla', 'ERCOT', 'North'])
    end
  end
end
