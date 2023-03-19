FactoryBot.define do
  factory :otp, :class => 'BxBlockForgotPassword::Otp' do    
    sequence(:email) { |n| "test#{n}@example.com" }
    otp {'1232'}
  end
end
