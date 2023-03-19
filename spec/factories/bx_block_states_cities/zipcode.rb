FactoryBot.define do
  factory :zipcode, :class => 'BxBlockStatesCities::Zipcode' do
  grid_type { "SPP" }
  code { "111111" }
  association  :city, factory: :city
  end
end
