FactoryBot.define do
  factory :otp_confirmation, :class => 'BxBlockForgotPassword::OtpConfirmation' do    
    sequence(:email) { |n| "test#{n}@example.com" }
  end
end
