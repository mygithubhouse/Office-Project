require 'rails_helper'      
RSpec.describe BxBlockStatesCities::State, type: :model do
	it { is_expected.to belong_to(:country_list)}
	it { should have_many :cities }

	it 'should add country code to city' do
		country = create(:country_list)
		state = build(:state, country_list_id: country.id)
		expect(state.country_code).to eq(nil)
		state.save
		expect(state.country_code).to eq(state.country_code)
	end

end

