module BxBlockContactUs
  class ContactSerializer < BuilderBase::BaseSerializer
    attributes *[
        :name,
        :email,
        :description,
    ]

    class << self
      private
      def user_for(object)
        "#{object.account.first_name} #{object.account.last_name}"
      end
    end
  end
end
