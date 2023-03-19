FactoryBot.define do
  factory :question_answer, :class => 'BxBlockHelpCentre::QuestionAnswer' do    
    question {'This is demo question?'}
    answer {'yes'}
  end
end
