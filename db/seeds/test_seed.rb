
terms = BxBlockContactUs::PrivacyPolicy.find_or_initialize_by(policy_type: 'terms_and_conditions')
terms.update(description: "To be changed by admin") unless terms.valid?
policy = BxBlockContactUs::PrivacyPolicy.find_or_initialize_by(policy_type: 'privacy_Policy')
policy.update(description: "To be changed by admin") unless policy.valid?


puts("Creating Countries")
BxBlockStatesCities::CountryList.where(alpha_code: "IN").destroy_all
BxBlockStatesCities::CountryList::COUNTRY_LIST.each do |country_key, country_value|
  BxBlockStatesCities::CountryList.find_or_create_by(alpha_code: country_key, name: country_value)
end
BxBlockCategories::Groups.call
state = BxBlockStatesCities::State.find_or_create_by(country_list_id: 1,  name: "Texas", alpha_code: "TX", country_code: "US")
city = BxBlockStatesCities::City.find_or_create_by(name: "TRAVIS", state_code: "TX", state_id: state.id)
zipocde = BxBlockStatesCities::Zipcode.find_or_create_by(code: "77777", city_id: city.id, grid_type: "ERCOT")


