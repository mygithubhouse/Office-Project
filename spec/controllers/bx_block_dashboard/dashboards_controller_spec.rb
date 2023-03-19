require 'rails_helper'
require 'webmock/rspec'

RSpec.describe BxBlockDashboard::DashboardsController, type: :controller do
  include MockRequestHelper

  let(:request_payload) do
    {
    'id_token' => token
    }
  end
  let(:response_body) do
    {"grid"=>"ERCOT", "dateformat"=>"YYYY-MM-DD\"T\"HH24", "timezone"=>"CST", "datestamp"=>"2023-02-07T06", "final"=>false, "algorithm"=>"alf", "week"=>[{"dow"=>"Tuesday", "grade"=>"B", "color_band"=>["#6495ed", "#6495ed", "#b0c4de", "#b0c4de", "#999999"]}, {"dow"=>"Wednesday", "grade"=>"B", "color_band"=>["#6495ed", "#6495ed", "#6495ed", "#6495ed", "#b0c4de"]}, {"dow"=>"Thursday", "grade"=>"A", "color_band"=>["#4169e1", "#4169e1", "#4169e1", "#0000ff", "#0000ff"]}, {"dow"=>"Friday", "grade"=>"C", "color_band"=>["#ffcc00", "#ffcc00", "#ffff00", "#ffff00", "#ffff00"]}, {"dow"=>"Saturday", "grade"=>"A", "color_band"=>["#0000ff", "#0000ff", "#0000ff", "#0000ff", "#4169e1"]}, {"dow"=>"Sunday", "grade"=>"A", "color_band"=>["#0000ff", "#0000ff", "#4169e1", "#4169e1", "#6495ed"]}, {"dow"=>"Monday", "grade"=>"C", "color_band"=>["#cccc33", "#cccc33", "#999999", "#999999", "#cccc33"]}]}
  end
  let(:response_sample) do
    [{"grid"=>"ERCOT", "dateformat"=>"YYYY-MM-DD\"T\"HH24", "timezone"=>"CST", "datestamp"=>"2023-02-07T06", "final"=>false, "algorithm"=>"alf", "week"=>[{"dow"=>"Tuesday", "grade"=>"B", "color_band"=>[8, 8, 7, 7, 6]}, {"dow"=>"Wednesday", "grade"=>"B", "color_band"=>[8, 8, 8, 8, 7]}, {"dow"=>"Thursday", "grade"=>"A", "color_band"=>[9, 9, 9, 10, 10]}, {"dow"=>"Friday", "grade"=>"C", "color_band"=>[3, 3, 4, 4, 4]}, {"dow"=>"Saturday", "grade"=>"A", "color_band"=>[10, 10, 10, 10, 9]}, {"dow"=>"Sunday", "grade"=>"A", "color_band"=>[10, 10, 9, 9, 8]}, {"dow"=>"Monday", "grade"=>"C", "color_band"=>[5, 5, 6, 6, 5]}]}, {"grid"=>"SPP", "dateformat"=>"YYYY-MM-DD\"T\"HH24", "timezone"=>"CST", "datestamp"=>"2023-02-07T06", "final"=>false, "algorithm"=>"alf", "week"=>[{"dow"=>"Tuesday", "grade"=>"D", "color_band"=>[2, 2, 3, 3, 3]}, {"dow"=>"Wednesday", "grade"=>"A", "color_band"=>[9, 10, 10, 10, 10]}, {"dow"=>"Thursday", "grade"=>"A", "color_band"=>[10, 10, 10, 10, 10]}, {"dow"=>"Friday", "grade"=>"B", "color_band"=>[5, 6, 7, 7, 8]}, {"dow"=>"Saturday", "grade"=>"A", "color_band"=>[10, 10, 10, 10, 10]}, {"dow"=>"Sunday", "grade"=>"B", "color_band"=>[8, 7, 6, 5, 5]}, {"dow"=>"Monday", "grade"=>"B", "color_band"=>[8, 8, 8, 7, 7]}]}, {"grid"=>"MISO", "dateformat"=>"YYYY-MM-DD\"T\"HH24", "timezone"=>"CST", "datestamp"=>"2023-02-07T06", "final"=>false, "algorithm"=>"alf", "week"=>[{"dow"=>"Tuesday", "grade"=>"D", "color_band"=>[2, 2, 2, 3, 3]}, {"dow"=>"Wednesday", "grade"=>"A", "color_band"=>[9, 10, 10, 10, 10]}, {"dow"=>"Thursday", "grade"=>"A", "color_band"=>[10, 10, 10, 10, 10]}, {"dow"=>"Friday", "grade"=>"B", "color_band"=>[5, 5, 6, 7, 7]}, {"dow"=>"Saturday", "grade"=>"A", "color_band"=>[10, 10, 10, 10, 10]}, {"dow"=>"Sunday", "grade"=>"B", "color_band"=>[7, 6, 6, 5, 4]}, {"dow"=>"Monday", "grade"=>"B", "color_band"=>[7, 7, 7, 7, 7]}]}]
  end

  def authenticated_header(user)
    token = BuilderJsonWebToken.encode(user.id, {account_type: user.type}, 1.year.from_now)
  end

  describe 'GET fleet_status' do
    before do
      @account = create(:account)
      @address = create(:address  ,addressble: @account )
    end
    context "when pass valid params" do
      it 'Returns params missing' do
        request.headers["token"] = authenticated_header(@account)
        get :fleet_status ,params: { late_night_status: nil}
        expect(response).to have_http_status(422)
      end

      it 'returns late night fleet status ' do
        request.headers["token"] = authenticated_header(@account)
        get :fleet_status ,params: { late_night_status: true}
      end

      it 'returns present day fleet status ' do
        request.headers["token"] = authenticated_header(@account)
        get :fleet_status ,params: { late_night_status: false}
      end
    end
  end

  describe 'GET weekly_data' do
    before do
       @account = create(:account)
    end
    context "when weekly data is present using besopke" do
      it 'returns success for inventory getter' do
        uri = 'http://evdead.com/inventory/getter'
        mock_api_call(uri, :get, response_sample)
        request.headers["token"] = authenticated_header(@account)
        get :weekly_data
        expect(JSON.parse(response.body)['response']).to eq(response_body)
      end
    end
  end
end
