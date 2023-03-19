require 'rails_helper'
RSpec.describe BxBlockAccountGroups::Group, :type => :model do
  let(:group) { @group = create(:group, name: "NewUser") }

  it { should validate_uniqueness_of(:name) }
  it { should have_and_belong_to_many :accounts }
  it { should have_many :posts }
  it { is_expected.to belong_to(:category) }

  context "callback" do
    context "when destroying basic groups" do
      it "Aborts deletion and throw error" do
        basic_group = described_class.where(name: 'NewUser').first
        response = basic_group.destroy
        expect(response).to eq(false)
        expect(basic_group.errors.messages).to include({:base=>["Basic group can't be destroyed"]})
      end
    end
    context "when updatiing basic groups" do
      it "Aborts updation and throw error" do
        basic_group = described_class.where(name: 'NewUser').first
        response = basic_group.update(name: "name to change")
        expect(response).to eq(false)
        expect(basic_group.errors.messages).to include({:base=>["Basic group can't be udpated"]})
      end
    end
    it { is_expected.to callback(:restrict_deletion).before(:destroy) }
  end
end


