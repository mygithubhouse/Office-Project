FactoryBot.define do
  factory :admin_user, :class => 'AdminUser' do
    sequence(:email) { |n| "test#{n}@admin.com" }
    password { "password" }
  end
end
