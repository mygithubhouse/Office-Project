module AccountBlock
  class BatteryPercentagesController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, only: %i[late_charging_status]
    before_action :load_account

    def late_charging_status
      render json: { late_charging_status: Time.zone.now.hour.between?(8, 18),
                     battery_percentage: @account.battery_percentage&.percent,
                     last_battery_percentage: @account.previous_night_battery&.percent,
                     late_night_charged: @account.updated_battery_response }
    end

    private

    def load_account
      @account = AccountBlock::Account.find_by(id: @token.id)
    end
  end
end
