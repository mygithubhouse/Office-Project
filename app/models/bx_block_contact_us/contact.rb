module BxBlockContactUs
  class Contact < BxBlockContactUs::ApplicationRecord
    self.table_name = :contacts

    belongs_to :account, class_name: "AccountBlock::Account"

    validates :name, :email, :description, presence: true
    validate :valid_email, if: Proc.new { |c| c.email.present? }

    def self.filter(query_params)
      ContactFilter.new(self, query_params).call
    end

    private

    def valid_email
      validator = AccountBlock::EmailValidation.new(email)
      errors.add(:email, "invalid") if !validator.valid?
    end
  end
end
