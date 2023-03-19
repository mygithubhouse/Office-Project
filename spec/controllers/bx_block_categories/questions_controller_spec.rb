require 'rails_helper'
RSpec.describe BxBlockCategories::QuestionsController, type: :controller do
 let(:question) { FactoryBot.create(:question) }
  
  describe 'POST create' do
    before(:each) do
      @question = create(:question)
    end
    context "when given correct credential" do
       it 'Returns success' do
        post :create, params: { question:{ content: "This is demo content", question_type: "Signup", options: ["FIRST", "SECOND", "THIR"] }}
        expect(response).to have_http_status(200)
      end
    end

    context "when given incorrect credential" do
       it 'Returns failed' do
        post :create, params: { question:{ question_type: "Signup", options: ["FIRST", "SECOND", "THIR"] }}
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'get index' do
    before(:each) do
      @question = create(:question)
      role = create(:role)
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when given correct credential" do
       it 'Returns success' do
        get :index, params: {token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'get show' do
    before(:each) do
      @question = create(:question)
      role = create(:role)
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when given correct credential" do
       it 'Returns success' do
        get :show, params: {token: @token, id: @question.id}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'put update' do
    before(:each) do
      @question = create(:question)
      role = create(:role)
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when given correct credential" do
       it 'Returns success' do
        put :update, params: {token: @token, id: @question.id ,question: { content: "update content",  }}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'Delete destroy' do
    before(:each) do
      @question = create(:question)
      role = create(:role)
      @account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
       it 'Returns Question deleted!' do
        delete :destroy, params: {id: @question.id }
        question = JSON.parse(response.body)
        expect(question['message']).to eq "Question deleted!"
      end
    end
  end
end




