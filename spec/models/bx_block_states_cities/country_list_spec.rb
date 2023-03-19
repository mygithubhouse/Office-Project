require 'rails_helper'      
RSpec.describe BxBlockStatesCities::CountryList, type: :model do
	it { should have_many :states }
end

