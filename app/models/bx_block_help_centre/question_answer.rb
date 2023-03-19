module BxBlockHelpCentre
  class QuestionAnswer < BxBlockHelpCentre::ApplicationRecord
    self.table_name = :question_answers
    validates :question, :answer, presence: true 
  end
end
