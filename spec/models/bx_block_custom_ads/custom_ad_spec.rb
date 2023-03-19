require 'rails_helper'      
RSpec.describe BxBlockCustomAds::CustomAd, type: :model do
	it { should have_one_attached :image }
	it { should have_one_attached :video }

end


