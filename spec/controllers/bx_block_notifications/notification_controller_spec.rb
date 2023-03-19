require 'rails_helper'
require 'webmock/rspec'

RSpec.describe BxBlockNotifications::NotificationsController, type: :controller do
  include MockRequestHelper
  NOTIFICATION_MESSAGE = "Test notification"
  VALID_CONTEXT = "when pass valid params"
  INVALID_CONTEXT = "when pass in valid params"


	let(:token) { "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQzN2FhNTA0MzgxMjkzN2ZlNDM5NjBjYTNjZjBlMjI4NGI2ZmMzNGQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiNjQ5NTkyMDMwNDk3LWdwM21vcWgwazJzcmM1cjJ1NXFmYW9yaWkxZHFrdmRjLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiNjQ5NTkyMDMwNDk3LWdwM21vcWgwazJzcmM1cjJ1NXFmYW9yaWkxZHFrdmRjLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTA4NzQ5NzQ1MTgyNTA4NTg2NDYzIiwiZW1haWwiOiJ5YXNobXRocjY1QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiTmIteWJRaE9IenlMUXFPQ0N5QmFFUSIsIm5hbWUiOiJZYXNoIE1hdGh1ciIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BRWRGVHA1UDVFbFdqcWNha0g2bHNnZnNCc1ZvRnZwLUJFZ2JudVRzZVNLOEZ6Yz1zOTYtYyIsImdpdmVuX25hbWUiOiJZYXNoIiwiZmFtaWx5X25hbWUiOiJNYXRodXIiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY3Mzg3OTA3NiwiZXhwIjoxNjczODgyNjc2LCJqdGkiOiIwM2UzM2YxZGZjNjczYTQwYWIyMTI4NDI0M2RiZTI5Y2IyMzRmM2Q2In0.ABPLdumT4ZTzcYqesU4wuMhOrsacTIiJpoZD5AxnsxFgSKzQjTVU7kcxI3WgMq9My9fcGQFJ7OhjNNfRKdB0iQ0z0nMB0gtgEYjfPlNIYWlF8fA6ow6zxeqpQLNfmv0D1_G8CDgg43VuX5YPM_l9qWWsQf4pBabVwvzbUsaWOdXLOSStoy5J5vv_V-XgstgMOGXuJtK8cSoc-nqK6X5MeS-WpjAoKxl-ovQWk-NVS6kp67WMA-_E7Me_IBOTooboQhBGEgaTJUtHG95GLj60Z2szeKxKLYVvDbtMAsw-asCIzkJ9R7l7almK2N3LiN8s1hinHdp0rNv0VrCKAfCcLQ" }

    let(:base_url) { "https://fcm.googleapis.com/v1/projects/" }
    let(:request_payload) do
    {
    'device_token' => token
    }
    end
    let(:response_body) do
    {
      'error_description' => "invalid Value"
    }
    end


  describe 'POST send  notifications' do
    context "when details are present" do
      it 'Returns success' do
        mock_api_call(base_url, :get, response_body.to_json)
      	# stub_request(:get, base_url).with(body: request_payload).to_return( body: response_body.to_json, status: 200)
        post :send_notification, params: { datetime: 5.minute.from_now.strftime("%Y-%m-%dT%H:%M"), message: NOTIFICATION_MESSAGE, device_tokens: [token] }
        expect(response).to have_http_status(200)
      end
    end
    context "when details are absent" do
      it 'Params missing' do
        post :send_notification
        response_sample = {"message"=>"Param missing"}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eql(response_sample)
      end
    end
  end

  describe 'Get index' do
    before(:each) do
      role = create(:role)
      @account = create(:account, role: role) 
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
      @notification = create(:notification, contents: NOTIFICATION_MESSAGE, account_id: @account.try(:id))
    end
    context "when given correct credentials" do
      it 'Returns success ' do
      get :index, params: {token: @token }
        expect(response).to have_http_status(200)
      end
    end
    context "when given incorrect credentials" do
      it 'Returns success ' do
      get :index, params: {token: nil }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      @role = create(:role)
      @account = create(:account, role: @role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
      @notification = create(:notification, contents: NOTIFICATION_MESSAGE, account_id: @account.try(:id))
    end
    context VALID_CONTEXT do
      it 'Returns show notification data' do
      get :show, params: { id: @notification&.id, token: @token }
      expect(response).to have_http_status(200)
      end
    end

    context INVALID_CONTEXT do
      it 'Returns show notification data' do
      get :show, params: { id: "id", token: @token }
      expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Update' do
    before(:each) do
      @role = create(:role)
      @account = create(:account, role: @role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
      @notification = create(:notification, contents: NOTIFICATION_MESSAGE, account_id: @account.try(:id))
    end
    context VALID_CONTEXT do
      it 'Update notification data' do
      get :update, params: { id: @notification&.id, token: @token }
      expect(response).to have_http_status(200)
      end
    end

    context INVALID_CONTEXT do
      it 'Returns not found error' do
      get :update, params: { id: "id", token: @token }
      expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Delete' do
    before(:each) do
      @role = create(:role)
      @account = create(:account, role: @role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
      @notification = create(:notification, contents: NOTIFICATION_MESSAGE, account_id: @account.try(:id))
    end
    context VALID_CONTEXT do
      it 'Delete notification data' do
      get :destroy, params: { id: @notification&.id, token: @token }
      expect(response).to have_http_status(200)
      end
    end

    context INVALID_CONTEXT do
      it 'Returns not found error' do
      get :destroy, params: { id: "id", token: @token }
      expect(response).to have_http_status(404)
      end
    end
  end
end

