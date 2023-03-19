module BxBlockContactUs
  class PrivacyPolicy < BxBlockContactUs::ApplicationRecord
    self.table_name = :privacy_policies
    enum policy_type: {"terms_and_conditions" => 0, "privacy_Policy" => 1}
    validates :description, :policy_type, :start_date, :end_date, presence: true
    after_update :update_term_and_condition_accepted_at
    after_update :update_privacy_policy_accepted_at

    def update_term_and_condition_accepted_at
    	if self.policy_type == 'terms_and_conditions'
	    	AccountBlock::Account.all.update_all(term_and_condition_accepted_at: nil)
    	end 
    end

    def update_privacy_policy_accepted_at
    	if self.policy_type == 'privacy_Policy'
            AccountBlock::Account.all.update_all(privacy_policy_accepted_at: nil)
        end 
    end

  end
end
