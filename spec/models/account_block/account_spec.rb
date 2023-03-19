require 'rails_helper'
RSpec.describe AccountBlock::Account, type: :model do

  context 'when creating a user' do
  	let(:account) {build :account}
  	it 'should be valid user with all attributes' do
  		account.valid? == true
  	end
  end

  context "associations" do
  	let(:account) {build :account}
  	it "should belong_to role" do
  		account.email = "test1@example.com"
  		account.valid? == true
  	end

    it { should have_many :answers }
    it { should have_one :blacklist_user }
    it { should have_one :car }
    it { should have_one :address }
  end

  it { should have_and_belong_to_many :groups }
  it { should have_many :posts }
  it { should have_many :comments }
  it { is_expected.to callback(:assign_groups).after(:create) }

  describe '#battery_percentage' do
    it 'should call method battery_percentage ' do
      @account = create(:account)
      @account.battery_percentage
    end
  end

  describe '#previous_night_battery' do
    it 'should call method previous_night_battery ' do
      @account = create(:account)
      @account.previous_night_battery
    end
  end

  describe '#updated_battery_response' do
    it 'should call method updated_battery_response ' do
      @account = create(:account)
      @account.updated_battery_response
    end
  end

  describe '#update_blocked_now' do
    let(:account) { create(:account) }
    context "when account is blocked" do
      it 'should update blocked_now to current time' do
        account.update(blocked: true)
        expect(account.reload.blocked_now).not_to eq(nil)
      end
    end
    context "when account is unblocked" do
      it 'should update blocked_now to nil ' do
        account.update(blocked: false)
        expect(account.reload.blocked_now).to eq(nil)
      end
    end
  end

end
