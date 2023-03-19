require 'rails_helper'
RSpec.describe BxBlockNotifsettings::EasyModesController, type: :controller do
  let(:account) { FactoryBot.create(:account) }
  VALID_CONTEXT = "when given correct credentials"
  INVALID_CONTEXT = "when given incorrect credentials"
  SUCCESS = "Returns success"
  ERROR = "Returns error"

  describe 'POST create for premium user' do
    before(:each) do
      role = create(:role, name:"Subscription")
      @account = create(:account, role: role) 
      @contact = create(:contact, account: @account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context VALID_CONTEXT do
      it SUCCESS do
      post :create, params: {token: @token, data: {"easy_modes": {"nights_ahead": "undecided","easy_prompt_time": "6:12 AM","second_easy_prompt_time": "7:00 AM"}} }
        expect(response).to have_http_status(201)
      end
    end
    context INVALID_CONTEXT do
      it ERROR do
      post :create, params: {data: {"easy_modes": {"nights_ahead": "undecided","easy_prompt_time": "6:12 AM","second_easy_prompt_time": "7:00 AM"}} }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'POST create for non premium user' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @contact = create(:contact, account: @account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context VALID_CONTEXT do
      it 'Returns error with non authorization' do
      post :create, params: {token: @token, data: {"easy_modes": {"nights_ahead": "undecided","easy_prompt_time": "7:42 AM","second_easy_prompt_time": "9:00 AM"}} }
        expect(response).to have_http_status(422)
      end
    end
    context INVALID_CONTEXT do
      it ERROR do
      post :create, params: {data: {"easy_modes": {"nights_ahead": "undecided","easy_prompt_time": "5:24 AM","second_easy_prompt_time": "6:30 AM"}} }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'Get index' do
    before(:each) do
      role = create(:role, name:"Subscription")
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context VALID_CONTEXT do
      it SUCCESS do
      get :index, params: {token: @token }
        expect(response).to have_http_status(200)
      end
    end
  end
end
