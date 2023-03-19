FactoryBot.define do
  factory :question, :class => 'BxBlockCategories::Question' do       
    question_type { 1 }
    content { "test123" }
    options { ["test3"] }
  end
end
