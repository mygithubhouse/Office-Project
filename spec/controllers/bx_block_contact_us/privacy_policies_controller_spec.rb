require 'rails_helper'
RSpec.describe BxBlockContactUs::PrivacyPoliciesController, type: :controller do
  let(:privacy_policies_one) { FactoryBot.create(:privacy_policies, policy_type: 1) }
  let(:privacy_policies_two) { FactoryBot.create(:privacy_policies, policy_type: 0) }
  describe 'Get index' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role)
      privacy_policies_one
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
    end
    context "when pass valid params for show privacy policies" do
      it 'Returns success ' do
      get :index, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'Get index' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
      BxBlockContactUs::PrivacyPolicy.delete_all
    end
    context "when pass invalid params for show privacy policies" do
      it 'Returns not_found ' do
      get :index, params: { token: @token}
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Get terms_and_condition_list' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role)
      privacy_policies_two
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it 'Returns success ' do
      get :terms_and_condition_list, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'Get terms_and_condition_list' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
      BxBlockContactUs::PrivacyPolicy.delete_all
    end
    context "when pass invalid params for show terms and condition list" do
      it 'Returns not_found ' do
      get :terms_and_condition_list, params: {token: @token}
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Get term_and_condition_accepted_or_not' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role, term_and_condition_accepted_at: false)
      privacy_policies_two
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
    end
    context "when pass valid params for terms and condition accepted or not" do
      it 'Returns success' do
      get :term_and_condition_accepted_or_not, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'Get term_and_condition_accepted_or_not' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role)
      privacy_policies_two
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
    end
    context "when pass valid params for terms and condition accepted or not" do
      it 'Returns success' do
      get :term_and_condition_accepted_or_not, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end


  describe 'Get privacy_policy_accepted_or_not' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role, privacy_policy_accepted_at: true)
      privacy_policies_one
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
    end
    context "when pass valid params for privacy policy accepted or not" do
      it 'Returns success' do
      get :privacy_policy_accepted_or_not, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end

   describe 'Get privacy_policy_accepted_or_not' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role, privacy_policy_accepted_at: false)
      privacy_policies_one
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
    end
    context "when pass valid params for privacy policy accepted or not" do
      it 'Returns success' do
      get :privacy_policy_accepted_or_not, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end
end
