FactoryBot.define do
  factory :password, :class => 'BxBlockForgotPassword::Password' do    
    sequence(:email) { |n| "test#{n}@example.com" }
  end
end
