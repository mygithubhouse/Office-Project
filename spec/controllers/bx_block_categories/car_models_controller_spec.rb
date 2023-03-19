require 'rails_helper'
RSpec.describe BxBlockCategories::CarModelsController, type: :controller do
 let(:car_makes) { FactoryBot.create(:car_makes) }
 let(:car_models) { FactoryBot.create(:car_models, car_make_id: car_makes.id) }

  describe 'GET index' do
    before(:each) do
	   car_models
    end
    context "when pass valid params for show car models" do
      it 'Returns success' do
        get :index , params: {car_make_id: car_makes.id}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET index' do
    context "when pass invalid params for show car models" do
      it 'Returns not_found' do
        get :index
        expect(response).to have_http_status(404)
      end
    end
  end
end