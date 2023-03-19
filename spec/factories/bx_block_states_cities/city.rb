FactoryBot.define do
  factory :city, :class => 'BxBlockStatesCities::City' do
  	sequence(:name) { |n| "test123#{n}" }
    association  :state
  end
end
