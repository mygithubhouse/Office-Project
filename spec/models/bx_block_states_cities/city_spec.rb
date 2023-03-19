require 'rails_helper'      
RSpec.describe BxBlockStatesCities::City, type: :model do
	it { is_expected.to belong_to(:state)}
	it { is_expected.to have_many(:zipcodes)}

	it 'should add state code to city' do
		state = create(:state, country_code: "IN")
		city = build(:city, state_id: state.id)
		expect(city.state_code).to eq(nil)
		city.save
		expect(city.state_code).to eq(state.alpha_code)
	end


end

