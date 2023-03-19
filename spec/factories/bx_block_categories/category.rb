FactoryBot.define do
  factory :category, :class => 'BxBlockCategories::Category' do
    sequence(:name) { |n| "test#{n}" }
  end
end
