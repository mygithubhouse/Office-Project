FactoryBot.define do
  factory :terms_and_conditions, :class => 'BxBlockContactUs::PrivacyPolicy' do
    description {'test123'}
    start_date { Time.now }
    end_date { Time.now }
    last_updated { Time.now }
    policy_type { 'terms_and_conditions' }
  end
end
