require 'rails_helper'
RSpec.describe AccountBlock::GroupCreation, type: :services do

end


require 'rails_helper'
RSpec.describe AccountBlock::GroupCreation, type: :services do
  subject { described_class.call }

  context '#Call' do
    before do
      BxBlockCategories::Groups.call
      create(:zipcode, grid_type: "SPP", code: "11111")
      create(:zipcode, grid_type: "MISO", code: "22222")
      create(:zipcode, grid_type: "ERCOT", code: "33333")
      create(:address, zipcode: 22222)
      create(:address, zipcode: 11111)
      create(:address, zipcode: 33333)
      create(:account, created_at: 1.month.before)
      create(:account, created_at: 5.month.before)
      create(:account, created_at: 15.month.before)
      subject
    end

    it "create respective categories" do
      account1 = AccountBlock::Account.joins(:address).where('addresses.zipcode = 22222').first
      account2 = AccountBlock::Account.joins(:address).where('addresses.zipcode = 11111').first
      account3 = AccountBlock::Account.joins(:address).where('addresses.zipcode = 33333').first
      account4 =  AccountBlock::Account.where("created_at > ?", 3.month.before).last
      account5 =  AccountBlock::Account.where(created_at: (11.month.before..3.month.before)).first
      account6 =  AccountBlock::Account.where(created_at: (18.month.before..11.month.before)).first
      expect(account1.groups.pluck(:name)).to include("MISO")
      expect(account2.groups.pluck(:name)).to include("SPP")
      expect(account3.groups.pluck(:name)).to include("ERCOT")
      expect(account4.groups.pluck(:name)).to include("NewUser")
      expect(account5.groups.pluck(:name)).to include("Experienced")
      expect(account6.groups.pluck(:name)).to include("Veteran")
    end
  end
end
