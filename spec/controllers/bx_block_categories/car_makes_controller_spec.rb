require 'rails_helper'
RSpec.describe BxBlockCategories::CarMakesController, type: :controller do
 let(:car_makes) { FactoryBot.create(:car_makes) }

  describe 'GET index' do
    before(:each) do
	   car_makes
    end
    context "when pass valid params for show car makes" do
      it 'Returns success' do
      get :index
      expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET index' do
    context "when pass invalid params for show car makes" do
      it 'Returns not_found' do
      get :index
      expect(response).to have_http_status(404)
      end
    end
  end
end