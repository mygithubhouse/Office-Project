FactoryBot.define do
  factory :user_badge, :class => 'BxBlockGamification::UserBadge' do
    badge
    account
    unlocked {false}
  end
end
