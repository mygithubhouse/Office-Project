FactoryBot.define do
  factory :account, :class => 'AccountBlock::Account' do
    full_phone_number { "+919773454625" }
    country_code { 1 }
    phone_number { 1 }
    activated { true }
    sequence(:first_name) { |n| "first_#{n}"}
    sequence(:last_name) { |n| "last_#{n}"}
    unique_auth_id { "test123" }
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:user_name) { |n| "test#{n}@example.com" }
    password {'test123'}
    password_confirmation {'test123'}
    type { "EmailAccount" }
    created_at { Time.now }
    updated_at { Time.now }
    question_choice_type { "Answer1" }
    sign_in_count {0}
    blocked {false}
    association :role
    # association :address
    after(:create) do |account|
        create(:car, account: account)
    end
  end
end
