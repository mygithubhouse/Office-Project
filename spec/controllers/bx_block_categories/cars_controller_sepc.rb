require 'rails_helper'
RSpec.describe BxBlockCategories::CarsController, type: :controller do

  describe 'GET dropdown_details' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it 'Returns success' do
      get :dropdown_details, params: {token: @token }
      expect(response).to have_http_status(200)
      end
    end
  end
end