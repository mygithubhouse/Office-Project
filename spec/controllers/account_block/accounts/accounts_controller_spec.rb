require 'rails_helper'
RSpec.describe AccountBlock::AccountsController, type: :controller do
  describe 'POST create' do
    before(:each) do
      role = create(:role, name: 'Free')
      @account = create(:account, role: role)
      @question = create(:question)
      create(:terms_and_conditions)
      create(:terms_and_conditions, policy_type: 'privacy_Policy')
    end
    context "when pass valid params" do
      it 'Returns success' do
      post :create, params: { data: { type: "email_account", attributes: { email: "test123@gmail.com", user_name: "test123@gmail.com", password: @account.password, password_confirmation: @account.password_confirmation, question_choice_type: @account.question_choice_type, address_attributes: { address: "ind", city: "pune", state_or_province: "mh", zipcode: "453010"}, car_attributes:{ car_name: "i20", electric_car_model: "hyundai", maximum_km: "10", electric_car_year: "2000", electric_car_make: "yes" }, answer_attributes: [{ question_id: @question.id, "answer": ["FIRST", "SECOND", "THIR"]},{ question_id: @question.id, answer: ["fefefefef"]}]} } }
      expect(response).to have_http_status(201)
      end
    end

    context "when pass invalid params" do
      it 'Returns failed' do
      post :create, params: { data: { type: "email_account", attributes: { email: @account.email, user_name: "test123@gmail.com", password: @account.password, password_confirmation: @account.password_confirmation, question_choice_type: @account.question_choice_type, address_attributes: { address: "ind", city: "pune", state_or_province: "mh", zipcode: "453010"}, car_attributes:{ car_name: "i20", electric_car_model: "hyundai", maximum_km: "10", electric_car_year: "2000", electric_car_make: "yes" }, answer_attributes: [{ question_id: @question.id, "answer": ["FIRST", "SECOND", "THIR"]},{ question_id: @question.id, answer: ["fefefefef"]}]} } }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)['errors']).to eql [{"message"=>"Email is already in use"}]
      end
    end

    context "when pass invalid params" do
      it 'Returns failed' do
      post :create, params: { data: { type: "email_account", attributes: { email: @account.email, user_name: "test123@gmail.com", question_choice_type: @account.question_choice_type, address_attributes: { address: "ind", city: "pune", state_or_province: "mh", zipcode: "453010"}, car_attributes:{ car_name: "i20", electric_car_model: "hyundai", maximum_km: "10", electric_car_year: "2000", electric_car_make: "yes" }, answer_attributes: [{ question_id: @question.id, "answer": ["FIRST", "SECOND", "THIR"]},{ question_id: @question.id, answer: ["fefefefef"]}]} } }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)['errors']).to eql [{"message"=>"Email is already in use"}]
      end
    end
  end

  describe "POST create" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
      @question = create(:question, answer_type: "RadioButton")
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass invalid params" do
      it "return Answer not permitted" do
      post :create, params: { data: { type: "email_account", attributes: { email: @account.email, user_name: "test123@gmail.com", question_choice_type: @account.question_choice_type, address_attributes: { address: "ind", city: "pune", state_or_province: "mh", zipcode: "453010"}, car_attributes:{ car_name: "i20", electric_car_model: "hyundai", maximum_km: "10", electric_car_year: "2000", electric_car_make: "yes" }, answer_attributes: [{ question_id: @question.id, "answer": ["FIRST", "SECOND", "THIR"]},{ question_id: @question.id, answer: ["fefefefef"]}]} } }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)['errors']).to eql "Answer not permitted"
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      @role = create(:role)
      @account = create(:account, role: @role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it 'Returns show user data' do
      get :show, params: { id: @account.id, token: @token }
      expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      role = create(:role)
      account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
    end
    context "when pass invalid params" do
      it 'Returns Record not found' do
      get :show, params: { id: 10000, token: @token }
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['errors']).to eql ["Record not found"]
      end
    end
  end


  describe "PUT update" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
      @question = create(:question)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it "return You have successfully changed your username!" do
        put :update, params: { token: @token, account: {name: "mandeepsss@124", email: "mandeepsingh@gmail.com", password: "test123", user_name: "mandeep", address_attributes:{address: "asfdghfhdfasdfndsfdgfg", city: "xyz", state_or_province: "uganada", zipcode: "452345"}, car_attributes: {car_name: "swift", electric_car_model: "vid", maximum_km: "20", electric_car_year: "2021", electric_car_make: "maruti"}, answer_attributes: [{question_id: @question.id, answer: "[\"one\", \"two\", \"threee\", \"four\"]"}, {question_id: @question.id, answer: "[\"aaaaa\", \"vvvvv\", \"vvvvvvv\", \"bbbbbbb\"]"}], preconditioning_type: "None", commute_distance: "20km", comfort_level: "normal", electric_vehicle_break: "no", other: "yes"}, "id"=>"39"}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['attributes']['user_name']).to eql 'mandeep'
      end
    end

    context "when pass valid params" do
      it "return You have successfully changed your email!" do
        put :update, params: { token: @token, account: {name: "mandeepsss@124", email: "mandeepsingh123@gmail.com", password: "test123", user_name: "mandeep", address_attributes:{address: "asfdghfhdfasdfndsfdgfg", city: "xyz", state_or_province: "uganada", zipcode: "452345"}, car_attributes: {car_name: "swift", electric_car_model: "vid", maximum_km: "20", electric_car_year: "2021", electric_car_make: "maruti"}, answer_attributes: [{question_id: @question.id, answer: "[\"one\", \"two\", \"threee\", \"four\"]"}, {question_id: @question.id, answer: "[\"aaaaa\", \"vvvvv\", \"vvvvvvv\", \"bbbbbbb\"]"}], preconditioning_type: "None", commute_distance: "20km", comfort_level: "normal", electric_vehicle_break: "no", other: "yes"}, "id"=>"39"}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['attributes']['email']).to eql 'mandeepsingh123@gmail.com'
      end
    end

    context "when pass invalid params" do
      it "return Question with id doesn't exists" do
        put :update, params: { token: @token, account: {name: "mandeepsss@124", email: "mandeepsingh123@gmail.com", password: "test123", user_name: "mandeep", address_attributes:{address: "asfdghfhdfasdfndsfdgfg", city: "xyz", state_or_province: "uganada", zipcode: "452345"}, car_attributes: {car_name: "swift", electric_car_model: "vid", maximum_km: "20", electric_car_year: "2021", electric_car_make: "maruti"}, answer_attributes: [{question_id: 1, answer: "[\"one\", \"two\", \"threee\", \"four\"]"}, {question_id: @question.id, answer: "[\"aaaaa\", \"vvvvv\", \"vvvvvvv\", \"bbbbbbb\"]"}], preconditioning_type: "None", commute_distance: "20km", comfort_level: "normal", electric_vehicle_break: "no", other: "yes"}, "id"=>"39"}
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "PUT update" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
      @question = create(:question, answer_type: "RadioButton")
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass invalid params" do
      it "return Answer not permitted" do
        put :update, params: { token: @token, account: {name: "mandeepsss@124", email: "mandeepsingh@gmail.com", password: "test123", user_name: "mandeep", address_attributes:{address: "asfdghfhdfasdfndsfdgfg", city: "xyz", state_or_province: "uganada", zipcode: "452345"}, car_attributes: {car_name: "swift", electric_car_model: "vid", maximum_km: "20", electric_car_year: "2021", electric_car_make: "maruti"}, answer_attributes: [{question_id: @question.id, answer: "[\"aaaaa\", \"vvvvv\", \"vvvvvvv\", \"bbbbbbb\"]"}], preconditioning_type: "None", commute_distance: "20km", comfort_level: "normal", electric_vehicle_break: "no", other: "yes"}, "id"=>"39"}
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)['errors']).to eql "Answer not permitted"
      end
    end
  end

  describe "Get check_user_name_validation" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
    end
    context "when check user_name validation for valid params" do
      it "return This username is unique" do
         get :check_user_name_validation, params: {user_name: "Mandeep@123"}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql ["This username is unique"]
      end
    end

    context "when check user_name validation for incorrect params" do
      it "return This username is already exists" do
         get :check_user_name_validation, params: {user_name: @account.user_name }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to eql ["This username is already exists"]
      end
    end
  end

  describe "Get check_email_validation for correct params" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
    end
    context "when pass email for already present" do
      it "return This email is already exists" do
         get :check_email_validation, params: {email: "test1@gmail.com" }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql ["This email is unique"]
      end
    end

    context "when pass email for not present" do
      it "return This email is unique" do
         get :check_email_validation, params: {email: @account.email}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to eql ["This email is already exists"]
      end
    end
  end

  describe "Put accept_privacy_policy" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid param" do
      it "return Privacy policy update successfully" do
        put :accept_privacy_policy, params: {token: @token, privacy_policy_accepted_at: Time.now }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql(["Privacy policy update successfully"])
      end
    end
  end

  describe "Put accept_term_and_condition" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid param" do
      it "return term and condition update successfully" do
        put :accept_term_and_condition, params: {use_route: '/accounts', token: @token, term_and_condition_accepted_at: Time.now }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql(["Term and condition update successfully"])
      end
    end
  end

  describe "Get search" do
    before do
      role = create(:role)
      account = create(:account, role: role)
      @token = BuilderJsonWebToken.encode(account.id, {account_type: account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it "return List of users." do
         get :search, params: {use_route: '/accounts', token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PUT add_battery_percentage" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
      @address = create(:address  ,addressble: @account )
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it "return Your battery percentage add successfully" do
        put :add_battery_percentage, params: {use_route: '/accounts', token: @token, id: @account.id, battery_percentage: 10}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql 'Your battery percentage add successfully'
      end
    end
    context "when record already exists" do
      before do
        create(:battery_percentage, account: @account)
      end
      it "updates the existing record" do
        put :add_battery_percentage, params: {use_route: '/accounts', token: @token, id: @account.id, battery_percentage: 10}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql 'Battery Percentage updated successfully'
      end
    end
  end

  describe "PUT late_battery_percentage" do
    before do
      @account = create(:account)
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it "return Your battery percentage add successfully" do
        put :late_battery_percentage, params: {use_route: '/accounts', token: @token, battery_percentage: 10}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eql 'Your battery percentage updated successfully'
      end
    end
    context "when record already exists" do
      before do
      @battery = create(:battery_percentage, account: @account, created_at: 1.day.before ,updated_at: 1.day.before)
      end
      it "updates the existing record" do
        put :late_battery_percentage, params: {use_route: '/accounts', token: @token, id: @account.id, battery_percentage: 20}
        expect(response).to have_http_status(200)
        expect(@battery.reload.late_charge).to eq(true)
      end
    end
  end

  describe "PUT add_battery_percentage" do
    before do
      role = create(:role)
      @account = create(:account, role: role)
      @address = create(:address  ,addressble: @account )
      @token = BuilderJsonWebToken.encode(@account.id, {account_type: @account.type}, 1.year.from_now)
    end
    context "when pass valid params" do
      it "return Already updated once cant update again" do
         put :add_battery_percentage, params: {use_route: '/accounts', token: @token, id: @account.id, battery_percentage: 20}
         expect(response).to have_http_status(200)
         expect(JSON.parse(response.body)['message']).to eql 'Your battery percentage add successfully'
      end
    end
  end

end
