require 'rails_helper'
RSpec.describe BxBlockStatesCities::StateCitiesController, type: :controller do
  describe 'GET countries' do
    context "when pass valid params" do
       it 'Returns success' do
        get :countries
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET states' do
    context "when pass valid params" do
       it 'Returns success' do
        get :states, params: {country_code: "US"}
        expect(response).to have_http_status(200)
      end
    end

    context "when pass invalid params" do
       it 'Returns failed' do
        get :states, params: {country_code: " "}
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['errors']).to eql "Please select Country code"
      end
    end
  end

describe 'GET cities' do
    context "when pass valid params" do
       it 'Returns success' do
        get :cities, params: {country_code: "IN", alpha_code: "HR"}
        expect(response).to have_http_status(200)
      end
    end

    context "when pass invalid params" do
       it 'Returns failed' do
        get :cities, params: {country_code: " ", alpha_code: ""}
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['errors']).to eql "Please select State code and Country code"
      end
    end
  end

  describe 'GET zipcode_validation' do
    context "when pass valid params" do
       it 'Returns success' do
        get :zipcode_validation, params: {zipcode: 452010, country: "IN"}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql "This is Valid zipcode"
      end
    end

    context "when pass invalid params" do
       it 'Returns failed' do
        get :zipcode_validation, params: {zipcode: 45201, country: "IN"}
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['errors']).to eql "This is invalid zipcode"
      end
    end  

    context "when pass invalid params" do
       it 'Returns failed' do
        get :zipcode_validation, params: {zipcode: "", country: " "}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to eql [{"country"=>"Value is not permitted"}]
      end
    end  

  end
end