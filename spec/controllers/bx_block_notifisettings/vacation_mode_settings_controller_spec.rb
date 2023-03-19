require 'rails_helper'
RSpec.describe BxBlockNotifsettings::VacationModeSettingsController, type: :controller do
  let(:account) { FactoryBot.create(:account) }
  
  describe 'POST create' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @contact = create(:contact, account: @account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when given correct credentials" do
      it 'Returns success' do
      post :create, params: {token: @token, data: {"vacation_mode_settings": {"vacation_begin": "02/12/2023","vacation_end": "02/19/2023","default_commitment": 1}} }
        expect(response).to have_http_status(201)
      end
    end
  end
  describe 'Get index' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when given correct credentials" do
      it 'Returns success ' do
      get :index, params: {token: @token }
        expect(response).to have_http_status(200)
      end
    end
  end
end
