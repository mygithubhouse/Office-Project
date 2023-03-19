# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# creating policies
terms = BxBlockContactUs::PrivacyPolicy.find_or_initialize_by(policy_type: 'terms_and_conditions')
terms.update(description: "To be changed by admin") unless terms.valid?
policy = BxBlockContactUs::PrivacyPolicy.find_or_initialize_by(policy_type: 'privacy_Policy')
policy.update(description: "To be changed by admin") unless policy.valid?

#creating role
BxBlockRolesPermissions::Role.create([{name: 'Admin'}, {name: 'Free'}, {name: 'Subscription'}])
admin_role = BxBlockRolesPermissions::Role.find_by(name: 'Admin')
admin = AdminUser.find_or_create_by(email: 'admin@windeverest.com')
admin.update(password: 'Admin@windeverest', role_id: admin_role.id) if admin.role_id.nil?

# creating Countries
puts("Creating Countries")
BxBlockStatesCities::CountryList.where(alpha_code: "IN").destroy_all
BxBlockStatesCities::CountryList::COUNTRY_LIST.each do |country_key, country_value|
  BxBlockStatesCities::CountryList.find_or_create_by(alpha_code: country_key, name: country_value)
end

# creating States, cities and zipcodes
# load 'db/seeds/ercot_zipcodes.rb'
# load 'db/seeds/spp_zipcodes.rb'
# load 'db/seeds/miso_zipcodes.rb'
# Creating Badges
load 'db/seeds/badges.rb'

# Creating Car Dropdown details
load 'db/seeds/car_dropdown_details.rb'

#creating groups
SeedData::GroupData.call
