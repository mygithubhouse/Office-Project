FactoryBot.define do
  factory :privacy_policies, :class => 'BxBlockContactUs::PrivacyPolicy' do
    description {'test123'}
    start_date { Time.now }
    end_date { Time.now }
    last_updated { Time.now }
    policy_type { 'privacy_Policy' }
  end
end
