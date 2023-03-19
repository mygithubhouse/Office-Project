require 'rails_helper'
RSpec.describe BxBlockAddress::Address, :type => :model do
  let (:address) { FactoryBot.create(:address) }
  # let!(:address_type) do 
    # { "Home": 0, "Work": 1, "Other": 2 }
  # end
  subject {BxBlockAddress::Address.new(address_type: "Other", city: "abcd", state_or_province: "abc", zipcode: 123443)}
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state_or_province) }
  it { is_expected.to validate_presence_of(:zipcode) }
  

  # it "has valid address type" do
  #   address_type.each do |type, value|
  #     subject.address_type = value
  #     subject.save
  #     expect(subject.address_type).to eql(type.to_s)
  #   end
  # end
end

  