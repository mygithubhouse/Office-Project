require 'rails_helper'
RSpec.describe BxBlockContactUs::ContactsController, type: :controller do
  let(:contact) { FactoryBot.create(:contact) }
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
      post :create, params: {token: @token, data: { email: "test@gmail.com.com", name: "text@123", description: "This is test" } }
        expect(response).to have_http_status(201)
      end
    end

    context "when given incorrect credentials" do
      it 'Returns errors' do
      post :create, params: {token: @token, data: { name: "bcccd@yopmail.com", description: "This is test" } }
        contact = JSON.parse(response.body)
        expect(contact['errors']).to eq [{"contact"=>["Email can't be blank"]}]      
      end
    end
  end


  describe 'Get show' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @contact = create(:contact, account: @account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when given correct credentials" do
      it 'Returns list' do
      get :show, params: {use_route: '/contacts/', token: @token,  id: @contact.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'Get show' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when given correct credentials" do
      it 'Returns list' do
      get :show, params: {use_route: '/contacts/', token: @token,  id: 1 }
        contact = JSON.parse(response.body)
        expect(contact['errors']).to eq [{"contact"=>"Contact Not Found"}]
      end
    end
  end

  describe 'Get index' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @contact = create(:contact, account: @account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when given correct credentials" do
      it 'Returns success ' do
      get :index, params: {token: @token, id: @contact.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'Put update' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @contact = create(:contact, account: @account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when update name" do
      it 'Returns update' do
      put :update, params: {token: @token , id: @contact.id, data:{ email: "mandeep@yopmail.com", name: "mandeep@yopmail.com", description: "This is test data" } }
        contact = JSON.parse(response.body)
        expect(contact['data']['attributes']['name']).to eq "mandeep@yopmail.com"
      end
    end

    context "when update email" do
      it 'Returns update' do
      put :update, params: {token: @token , id: @contact.id, data:{ email: "mandeep@yopmail.com", name: "mandeeptest@yopmail.com", description: "This is test data" } }
        contact = JSON.parse(response.body)
        expect(contact['data']['attributes']['email']).to eq "mandeep@yopmail.com"
      end
    end
  end


  describe 'Delete destroy' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @contact = create(:contact, account: @account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when destroy" do
      it 'Returns Contact destroyed successfully' do
      delete :destroy, params: {token: @token , id: @contact.id }
        contact = JSON.parse(response.body)
        expect(contact['message']).to eq "Contact destroyed successfully"
      end
    end
  end

end