module BxBlockComments
  class CommentSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer
    attributes *[
        :id,
        :post,
        :comment,
        :created_at,
        :updated_at,
        :account
    ]
  end
end
