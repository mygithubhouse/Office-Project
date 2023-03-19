require 'rails_helper'
require 'webmock/rspec'
RSpec.describe AccountBlock::AddBatteryPercentageWorker do
  include MockRequestHelper

  let(:account1) { create(:account) }
  let(:account2) { create(:account, created_at: 5.months.ago) }
  let(:account4) { create(:account, created_at: 19.months.ago) }
  let(:account5) { create(:account, created_at: 15.months.ago) }
  let(:account3) { create(:account) }
  let(:batter_percentage1) { create(:battery_percentage, created_at: Time.zone.now.hour < 8 ? (2.days.before - 8.hours) : (1.day.before - 8.hours), account: account1) }
  let(:batter_percentage3) { create(:battery_percentage, created_at: Time.zone.now.hour < 8 ? (Time.zone.now - 8.hours) : (1.day.before - 8.hours), account: account3) }
  let(:response_sample) do
    [
      {"grid"=>"ERCOT", "dateformat"=>"YYYY-MM-DD\"T\"HH24", "timezone"=>"CST", "datestamp"=>"2023-02-07T06", "final"=>false, "algorithm"=>"alf",
        "week"=>[
     {"dow"=>"Tuesday", "grade"=>"B", "color_band"=>[8, 8, 7, 7, 6]},
     {"dow"=>"Wednesday", "grade"=>"B", "color_band"=>[8, 8, 8, 8, 7]},
     {"dow"=>"Thursday", "grade"=>"A", "color_band"=>[9, 9, 9, 10, 10]},
     {"dow"=>"Friday", "grade"=>"C", "color_band"=>[3, 3, 4, 4, 4]},
     {"dow"=>"Saturday", "grade"=>"A", "color_band"=>[10, 10, 10, 10, 9]},
     {"dow"=>"Sunday", "grade"=>"A", "color_band"=>[10, 10, 9, 9, 8]},
     {"dow"=>"Monday", "grade"=>"C", "color_band"=>[5, 5, 6, 6, 5]} ]}
    ]
  end
  before do
    batter_percentage1
    batter_percentage3
    account2.groups << BxBlockAccountGroups::Group.find_by(name: 'NewUser')
    account4.groups << BxBlockAccountGroups::Group.find_by(name: 'Veteran')
    account5.groups << BxBlockAccountGroups::Group.find_by(name: 'Experienced')
    account4
    account5
    uri = 'http://evdead.com/inventory/getter'
    mock_api_call(uri, :get, response_sample)
    subject.perform
  end
  it "change the group if user's created_at is before 4 month" do
    expect(account2.groups.pluck(:name)).to include('Experienced')
    expect(account2.groups.pluck(:name)).not_to include('NewUser')
  end
  it "change the group if user's created_at is before 12 month" do
    expect(account5.groups.pluck(:name)).to include('Veteran')
    expect(account5.groups.pluck(:name)).not_to include('Experienced')
  end
  it "change the group if user's created_at is before 18 month" do
    expect(account4.groups.pluck(:name)).to include('SuperUser')
    expect(account4.groups.pluck(:name)).not_to include('Veteran')
  end
end
