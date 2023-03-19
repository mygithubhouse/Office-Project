FactoryBot.define do
  factory :state, :class => 'BxBlockStatesCities::State' do
	  sequence(:alpha_code) { |n| "MP#{n}" }
	  association :country_list
  end
end
