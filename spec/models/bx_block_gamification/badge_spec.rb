require 'rails_helper'
RSpec.describe BxBlockGamification::Badge, type: :model do
  it { should have_one_attached :unlocked_image }
  it { should have_one_attached :locked_image }
  
  it "should have many user_badges" do
    t = badge.reflect_on_association(:user_badges)
    expect(t.macro).to eq(:has_many)
  end
end