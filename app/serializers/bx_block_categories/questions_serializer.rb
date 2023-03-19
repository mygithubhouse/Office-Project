# frozen_string_literal: true

module BxBlockCategories
  class QuestionsSerializer < BuilderBase::BaseSerializer
    attributes :id, :content, :question_type, :answer_type, :options

    attribute :content do |coupon|
      coupon.content.as_json
    end

    attribute :question_type do |coupon|
      coupon.question_type.as_json
    end
  end
end
