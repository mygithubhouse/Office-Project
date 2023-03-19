module BxBlockAccountGroups
  class GroupSerializer < BuilderBase::BaseSerializer
    attributes :name
    attribute :members do |object|
      object.accounts.map {|acc| {id: acc.id, email: acc.email, name: "#{acc.first_name} #{acc.last_name}"} }
    end
  end
end
