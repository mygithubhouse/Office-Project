require 'rails_helper'
RSpec.describe BxBlockCustomAds::CustomAdsController, type: :controller do
  include LoginHelper
  let(:custom_ad) { FactoryBot.create(:custom_ad) }
  let(:account) { create(:account) }
  let(:admin_user) { create(:admin_user) }

  describe 'POST create' do
    before(:each) do
      custom_ad = create(:custom_ad)
    end
    context "free user can not create" do
      it 'Returns unauthorized' do
        request.headers["token"] = authenticated_header(account)
        post :create, params: { custom_ad: { title: "demo", status: true, view_count: 1, click_count: 1, message: "test123", link: "example.com", start_date: Time.now, end_date: Time.now } }
       expect(response).to have_http_status(401)
      end
    end
    context "admin user can create" do
      it 'Returns success' do
        request.headers["token"] = authenticated_header(admin_user)
        post :create, params: { custom_ad: { title: "demo", status: true, view_count: 1, click_count: 1, message: "test123", link: "example.com", start_date: Time.now, end_date: Time.now } }
        sample_respone = ['title', 'start_date', 'end_date', 'status', 'link', 'message', 'view_count', 'click_count', 'created_at', 'updated_at', 'image', 'video']
       expect(response).to have_http_status(201)
       expect(JSON.parse(response.body)['data']['attributes'].keys).to eq(sample_respone)
      end
    end
  end

  describe 'GET index' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
      custom_ad = create(:custom_ad)
    end
    context "when pass valid params" do
      it 'Returns success' do
      get :index, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end

   describe 'GET index' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass invalid params" do
      it 'Returns failed' do
      get :index, params: {token: @token}
      custom_ads =  JSON.parse(response.body)
      expect(custom_ads['data']).to eq []

      end
    end
  end

  describe 'PUT update_click_count' do
    before(:each) do
      @custom_ad = create(:custom_ad)
    end
    context "when pass valid params" do
      it 'Returns success' do
      put :update_click_count, params: {custom_ad_id: @custom_ad.id}
        expect(response).to have_http_status(200)
      end
    end
    context "For invalid id" do
      it 'Returns not found' do
        ad = build_stubbed(:custom_ad)
        put :update_click_count, params: {custom_ad_id: ad.id}
        expect(JSON.parse(response.body)).to eq({'message' =>'Custom Ads Not Found'})
        expect(response).to have_http_status(404)
      end
    end
  end
end

