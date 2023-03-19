FactoryBot.define do
  factory :contact, :class => 'BxBlockContactUs::Contact' do    
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:name) { |n| "test#{n}@example.com" }
    description {'test123'}
  end
end
