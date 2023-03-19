FactoryBot.define do
  factory :address, :class => 'BxBlockAddress::Address' do
    country { "UK" }
    latitude { "test123" }
    longitude { "test123" }
    address_type { 1 }
    created_at { Time.now }
    updated_at { Time.now }
    address { "test123" }
    zipcode { "73301" }
    city { "test123" }
    state_or_province { "test123" }
    association :addressble, factory: :account
  end
end

