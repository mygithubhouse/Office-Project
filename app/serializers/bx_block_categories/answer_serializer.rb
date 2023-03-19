module BxBlockCategories
  class AnswerSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer
    attributes *[
        :content, 
    ]

    attribute :content do |object|
        object.answer_content
    end

  end
end
