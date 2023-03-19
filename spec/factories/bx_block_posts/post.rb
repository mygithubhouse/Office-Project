FactoryBot.define do
  factory :post, :class => 'BxBlockPosts::Post' do
    sequence(:name) { |n| "test#{n}@example.com" }
    body {'test123'}
    association :account
    association :group
  end
end
