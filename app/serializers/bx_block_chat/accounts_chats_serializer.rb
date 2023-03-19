module BxBlockChat
  class AccountsChatsSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer

    attributes :account_id, :muted
  end
end
