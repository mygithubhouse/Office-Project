require 'rails_helper'      
RSpec.describe BxBlockContactUs::PrivacyPolicy, type: :model do
   let!(:policy_type) do 
    { "Terms_and_conditions" => 0, "privacy_Policy" => 1}
   end
  subject {BxBlockContactUs::PrivacyPolicy.new(description: "test123", policy_type: "privacy_Policy", start_date: "Time.now", end_date: "1.year.after")}

    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:policy_type) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

end


