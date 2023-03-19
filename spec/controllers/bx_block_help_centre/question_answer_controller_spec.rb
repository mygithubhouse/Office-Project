require 'rails_helper'
RSpec.describe BxBlockHelpCentre::QuestionAnswerController, type: :controller do

  describe 'POST create' do
    before do 
      role = create(:role)
      @account = create(:account, role: role)
      @question_answer = create(:question_answer)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it 'Returns created' do
        post :create, params: {use_route: '/question_answer', question_answer:{question: "Test question", answer: "yes"}}
        expect(response).to have_http_status(201)
      end
    end

    context "when pass invalid params" do
      it 'Returns failed' do
        post :create, params: {use_route: '/question_answer', question_answer:{question: " ", answer: "yes"}}
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET index' do
    before do 
     role = create(:role)
      @account = create(:account, role: role)
      @question_answer = create(:question_answer)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it 'Returns show list all Question Answer' do
        get :index, params: {use_route: '/question_answer', token: @token}
        expect(response).to have_http_status(200)
      end
    end
    context "when pass invalid params" do
      it 'Returns Account not found' do
        get :index, params: {use_route: '/question_answer', token: "dfnknkldnvkldnlkdlknvkld32332"}
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)['errors']).to eql [{"token"=>"Invalid token"}]
      end
    end
  end

   describe 'GET index' do
    before do 
      role = create(:role)
      @account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass invalid params" do
      it 'Returns No question found' do
        get :index, params: {use_route: '/question_answer', token: @token}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to eql [{"message"=>"No question found."}]
      end
    end
  end

  describe 'GET show' do
    before do 
      role = create(:role)
      @account = create(:account, role: role)
      @question_answer = create(:question_answer)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it 'Returns list Question Answer' do
        get :show, params: {use_route: '/question_answer', token: @token, id: @question_answer.id}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE Destroy' do
    before do 
      role = create(:role)
      @account = create(:account, role: role)
      @question_answer = create(:question_answer)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when delete question_answer for valid params" do
      it 'Returns Question answer deleted.' do
        delete :destroy, params: {use_route: '/question_answer', token: @token, id: @question_answer.id}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql 'Question answer deleted.'
      end
    end
  end

  describe 'DELETE Destroy' do
    before do 
      role = create(:role)
      @account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when delete question_answer for invalid params" do
      it 'Returns Question answer did not delete.' do
        delete :destroy, params: {use_route: '/question_answer', token: @token, id: 11111}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to eql [{"message"=>"Question not found."}]
      end
    end
  end

  describe 'PUT update' do
    before do 
      role = create(:role)
      @account = create(:account, role: role)
      @question_answer = create(:question_answer)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it 'Returns updated successfully' do
        put :update, params: {use_route: '/question_answer', token: @token, id: @question_answer.id, question_answer:{answer: "yes"}}
        expect(response).to have_http_status(200)
      end
    end
    
    context "when pass invalid params" do
      it 'Returns errors' do
        put :update, params: {use_route: '/question_answer', token: @token, id: 10, question_answer:{answer: "yes"}}
        expect(response).to have_http_status(422)
      end
    end
  end

end