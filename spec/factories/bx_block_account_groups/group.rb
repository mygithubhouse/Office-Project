FactoryBot.define do
  factory :group, :class => 'BxBlockAccountGroups::Group' do
    sequence(:name) { |n| "test_group#{n}" }
    association :category
  end
end
