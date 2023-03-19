FactoryBot.define do
  factory :role, :class => 'BxBlockRolesPermissions::Role' do
    sequence(:name) { |n| "Free#{n}"}
  end
end
