require 'rails_helper'
RSpec.describe BxBlockContactUs::PreviewVideosController, type: :controller do
  
  describe 'Get index' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it 'Returns success ' do
      get :index, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
    context "when pass invalid params" do
      it 'Returns invalid token' do
      get :index, params: {token: 1}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)['errors']).to eql [{"token"=>"Invalid token"}]
      end
    end
  end
end
