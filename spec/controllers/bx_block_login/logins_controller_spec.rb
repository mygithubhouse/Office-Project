require 'rails_helper'
RSpec.describe BxBlockLogin::LoginsController, type: :controller do
 let(:account) { FactoryBot.create(:account , activated: true) }
 let(:admin_user) { create(:admin_user) }
 let(:privacy_policy) { create(:privacy_policies) }
 let(:terms_and_conditions) { create(:terms_and_conditions) }
  describe 'POST login' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role)
      privacy_policy
      terms_and_conditions
    end
    context "when pass valid params" do
       it 'Returns success' do
        post :create, params: {use_route: '/login/', data: { type: "email_account", attributes: { email: @account.email, password: @account.password }, device: "android" } }
        expect(response).to have_http_status(200)
      end
    end
    context "when pass invalid password" do
       it 'Returns failed_login' do
        post :create, params: {use_route: '/login/', data: { type: "email_account", attributes: { email: @account.email, password: "psw" }, device: "android" } }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to eql [{"failed_login"=>"Password is incorrect"}]
      end
    end
  end

   describe 'POST login' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role, activated: false)
    end
    context "when pass Invalid account" do
       it 'Returns failed_login' do
        post :create, params: {use_route: '/login/', data: { type: "email_account", attributes: { email: @account.email, password: @account.password }, device: "android" } }
        expect(response).to have_http_status(422)
      end
    end

    context "when pass Invalid params" do
      it 'Returns failed_login' do
        post :create, params: {use_route: '/login/', data: { type: "email_account", attributes: { email: @account.email, password: "Password123" }, device: "android" }}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to eql [{"failed_login"=>"Account not found, or not activated"}]
      end
    end

    context "when pass account type" do
      it 'Returns Invalid Account Type' do
        post :create, params: { use_route: '/login/', data: { type: "other_account", attributes: {  email: "mandeeps.com", password: "123" }, device: "android" }}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to eql [{"account"=>"Invalid Account Type"}]
      end
    end
    context "login with admin account" do
      it 'Returns success response' do
        post :create, params: { use_route: '/login/', data: { type: "other_account", attributes: {  email: admin_user.email, password: admin_user.password }}}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to eql [{"account"=>"Invalid Account Type"}]
      end
    end
  end

  describe 'POST login' do
    before(:each) do
      role = create(:role)
      @account = create(:account, sign_in_count: 4, role: role)
    end
    context "when pass incorrect password multiple time" do
       it 'Returns Account Blocked' do
        post :create, params: {use_route: '/login/', data: { type: "email_account", attributes: { email: @account.email, password: "test"}, device: "android" } }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to eql "Your Account has been block! You need to change your password"
      end
    end
  end

  describe 'POST login' do
    before(:each) do
      role = create(:role)
      @account = create(:account, sign_in_count: 4, blocked: true, role: role)
    end
    context "when pass incorrect password multiple time" do
       it 'Returns Account Blocked' do
        post :create, params: {use_route: '/login/', data: { type: "email_account", attributes: { email: @account.email, password: "test"}, device: "android" } }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to eql "Your Account has been blocked. Please unblock it first"
      end
    end
  end

end

