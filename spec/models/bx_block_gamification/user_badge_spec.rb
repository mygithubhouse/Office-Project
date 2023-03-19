require 'rails_helper'
RSpec.describe BxBlockGamification::UserBadge, type: :model do
  it { is_expected.to belong_to(:account) }
  it { is_expected.to belong_to(:badge) }
  let!(:account) { create(:account) }
  let!(:battery_percentage) { build(:battery_percentage, account: account, percent: 60.0, grade: "A") }
  let!(:user_badge) { build(:user_badge, account: account) }
  describe "Assign badges" do
    context 'Assign badges to user as per achivements' do
      it 'Cancel paypal subscription' do
        object = BxBlockGamification::UserBadge.assign_starter_badge
        object = BxBlockGamification::UserBadge.assign_hard_charger_badge
        object = BxBlockGamification::UserBadge.assign_a_roll_badge
        object = BxBlockGamification::UserBadge.assign_redeemed_badge
        object = BxBlockGamification::UserBadge.assign_fully_charged_badge
        object = BxBlockGamification::UserBadge.assign_overachiever_badge
        object = BxBlockGamification::UserBadge.assign_camel_badge
        object = BxBlockGamification::UserBadge.assign_straight_as_badge
        object = BxBlockGamification::UserBadge.assign_discriminatings_badge
        object = BxBlockGamification::UserBadge.assign_upgraded_badge
      end
    end
  end
end
