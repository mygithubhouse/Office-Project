FactoryBot.define do
  factory :comment, :class => 'BxBlockComments::Comment' do
    sequence(:comment) { |n| "test#{n}" }
    association :account
    association :post
  end
end
