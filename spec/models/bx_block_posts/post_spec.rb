require 'rails_helper'
RSpec.describe BxBlockPosts::Post, type: :model do

  context "associations" do
    it { should have_many :comments }
    it { should belong_to(:group) }
    it { should belong_to(:account) }
  end
end
