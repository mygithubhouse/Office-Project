module BxBlockCategories
  class Answer < BxBlockCategories::ApplicationRecord
    self.table_name = :answers
    belongs_to :account
    belongs_to :question, class_name: "BxBlockCategories::Question",
      foreign_key: "question_id"
    # validates :car_name, :electric_car_model, :maximum_km, :electric_car_year, :electric_car_make, presence: true

    def answer_content
    	return content if question.Text?
    	JSON.parse(content)
    end
  end
end
