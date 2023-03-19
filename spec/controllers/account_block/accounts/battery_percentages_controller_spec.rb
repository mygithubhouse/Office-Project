require 'rails_helper'
RSpec.describe AccountBlock::BatteryPercentagesController, type: :controller do
  def authenticated_header(user)
    token = BuilderJsonWebToken.encode(user.id, {account_type: user.type}, 1.year.from_now)
  end

  describe "Get late_charging_status" do
    before do
      @account = create(:account)
      @battery_percentage = create(:battery_percentage, account: @account)
    end
    context "when pass valid params" do
      it "return List of users." do
        request.headers["token"] = authenticated_header(@account)
        get :late_charging_status
        expect(response).to have_http_status(200)
        sample_response = {"late_charging_status"=>true, "battery_percentage"=>45.0, "last_battery_percentage"=>nil, "late_night_charged"=>false}
        sample_response = {"late_charging_status"=>false, "battery_percentage"=>45.0, "last_battery_percentage"=>nil, "late_night_charged"=>false} unless Time.zone.now.hour.between?(8, 18)
        expect(JSON.parse(response.body)).to eql(sample_response)
      end
    end
  end
end
