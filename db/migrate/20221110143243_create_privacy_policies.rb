class CreatePrivacyPolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :privacy_policies do |t|
      t.text :description
      t.integer :policy_type
      t.timestamp :start_date, default: Time.now
      t.timestamp :end_date, default: 1.year.after
      t.timestamps
    end
  end
end
