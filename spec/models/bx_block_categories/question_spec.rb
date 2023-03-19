require 'rails_helper'

RSpec.describe BxBlockCategories::Question, :type => :model do
 
  subject {BxBlockCategories::Question.new(content: "Test", question_type: "Signup")}
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:question_type) }
end

  


