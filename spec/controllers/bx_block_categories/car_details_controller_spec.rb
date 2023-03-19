require 'rails_helper'
RSpec.describe BxBlockCategories::CarDetailsController, type: :controller do
 let(:car_details) { FactoryBot.create(:car_details) }

  describe 'GET index' do
    before(:each) do
	   car_details
    end
    context "when pass valid params for show car details" do
      it 'Returns success' do
      get :index
      expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET index' do
    context "when pass invalid params for show car details" do
      it 'Returns not_found' do
      get :index
      expect(response).to have_http_status(404)
      end
    end
  end
end