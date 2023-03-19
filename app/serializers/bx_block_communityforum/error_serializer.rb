module BxBlockCommunityforum
  class ErrorSerializer < BuilderBase::BaseSerializer
    attribute :errors do |community|
      community.errors.as_json
    end
  end
end
