require 'rails_helper'
RSpec.describe BxBlockCustomAds::CustomAdsExpireWorker do
  let(:custom_ad) { create(:custom_ad, start_date: 2.day.before, end_date: 1.day.before, status: true) }
  it 'changes status for expired ads' do
    custom_ad
    subject.perform
    expect(custom_ad.reload.status).to eq(false)
  end
end
