# frozen_string_literal: true

module BxBlockCategories
  class Question < BxBlockCategories::ApplicationRecord
    self.table_name = :questions
    ANSWER_TYPES = %w(RadioButton Checkbox Dropdown).freeze

    has_many :answers, class_name: 'BxBlockCategories::Answer'
    validates :content, :question_type, presence: true
    validates :content, uniqueness: true
    validates_presence_of :options, if: proc { |a| ANSWER_TYPES.include?(a.answer_type) }

    enum question_type: { 'Profile' => 0, 'Signup' => 1 }
    enum answer_type: { 'Text' => 0, 'RadioButton' => 1, 'Checkbox' => 2, 'Dropdown' => 3}
    enum display: {'Yes' =>0, 'No' =>1}
  end
end
