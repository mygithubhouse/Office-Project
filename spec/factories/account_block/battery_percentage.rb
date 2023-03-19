FactoryBot.define do
  factory :battery_percentage, :class => 'AccountBlock::BatteryPercentage' do
    percent { 45.0 }
    grade { "A" }
    association :account
  end
end
