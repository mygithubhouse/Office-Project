FactoryBot.define do
  factory :preview_video, :class => 'BxBlockCategories::PreviewVideo' do    
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:name) { |n| "test#{n}@example.com" }
    description {'test123'}
  end
end
