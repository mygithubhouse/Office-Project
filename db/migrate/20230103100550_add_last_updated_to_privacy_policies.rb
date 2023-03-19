class AddLastUpdatedToPrivacyPolicies < ActiveRecord::Migration[6.0]
  def change
	add_column :privacy_policies, :last_updated, :datetime
  end
end
