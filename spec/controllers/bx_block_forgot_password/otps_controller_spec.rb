require 'rails_helper'
RSpec.describe BxBlockForgotPassword::OtpsController, type: :controller do

  describe 'POST create' do
    before do
      role = create(:role)
      @account = create(:account, role: role)
    end
    context "when pass valid params" do
      it 'Returns success' do
        post :create, params: { data: { attributes: { email: @account.email } } }
        expect(response).to have_http_status(201)
      end
    end
    context "when pass invalid params" do
      it 'Returns Account not found' do
        post :create, params: { data: { attributes: { email: "dsds@yopmail.com" } } }
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['errors']).to eql [{"account"=>"Account not found"}]
      end
    end
  end
end

