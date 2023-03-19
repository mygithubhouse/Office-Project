class AddPrivacyPolicyFieldsToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :privacy_policy_accepted_at, :datetime
    add_column :accounts, :term_and_condition_accepted_at, :datetime
  end
end
