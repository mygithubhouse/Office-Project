# frozen_string_literal: true

module BxBlockDashboard
  # dashboard controller
  class DashboardsController < ApplicationController
    require 'httparty'
    COLOR_MAPPING = { 1 => '#ff0000', 2 => '#ff9933', 3 => '#ffcc00', 4 => '#ffff00', 5 => '#cccc33', 6 => '#999999',
                      7 => '#b0c4de', 8 => '#6495ed', 9 => '#4169e1', 10 => '#0000ff' }.freeze
    BESPOKE_URL = 'http://evdead.com/inventory/getter'
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, only: %i[weekly_data fleet_status]
    before_action :load_account, only: %i[weekly_data fleet_status]
    before_action :load_dashboard, only: %i[show update destroy]
    # before_action :total_zips, only: %i[total_records , fleet_status]

    def weekly_data
      response = HTTParty.get(BESPOKE_URL)
      return render json: { response: response.body }, status: response.code unless response.code == 200

      updated_response =  JSON.parse(response)
      week_data = updated_response.first['week']
      arr = week_data.map do |status|
        { 'dow' => status['dow'], 'grade' => status['grade'],
          'color_band' => status['color_band'].map { |x| COLOR_MAPPING[x] } }
      end
      updated_response.first['week'] = arr
      render json: { response: updated_response.first }, status: 200
    end

    def time_stamps
      if params[:late_night_status] == 'true'
        if Time.zone.now.hour < 8
          start_time = 2.day.before.beginning_of_day.plus_with_duration(8.hours)
          end_time = 2.day.before.end_of_day.plus_with_duration(8.hours)
        else
          start_time = 1.day.before.beginning_of_day.plus_with_duration(8.hours)
          end_time = 1.day.before.end_of_day.plus_with_duration(8.hours)
        end
      else
        if Time.zone.now.hour < 8
          start_time = 1.day.before.beginning_of_day.plus_with_duration(8.hours)
          end_time = 1.day.before.end_of_day.plus_with_duration(8.hours)
        else
          start_time = Time.zone.now.beginning_of_day.plus_with_duration(8.hours)
          end_time = Time.zone.now.end_of_day.plus_with_duration(8.hours)
        end
      end
      [start_time, end_time]
    end

    def total_zips
      grid = BxBlockStatesCities::Zipcode.find_by(code: @account.address.zipcode.to_s)&.grid_type
      zips = BxBlockStatesCities::Zipcode.all.where(grid_type: grid).pluck(:code).to_a
      [grid, zips]
    end

    def total_records
      grid, zips = total_zips
      total = AccountBlock::Account.includes(:address).where(addresses: { zipcode: zips&.map(&:to_i) })
      if grid.nil?
        zips = BxBlockStatesCities::Zipcode.pluck(:code)
        total = AccountBlock::Account.includes(:address).where.not(addresses: { zipcode: zips&.map(&:to_i) })
      end
      total
    end

    def fleet_status
      return render json: { error: 'param missing' }, status: 422 if params[:late_night_status].blank?

      start_time, end_time = time_stamps
      total = total_records
      decline_value = total.includes(:battery_percentages).where(battery_percentages:
        { status: 0, created_at: start_time..end_time }).count.to_f
      decline = ((decline_value / total.count) * 100).floor(2)
      charged_value = total.includes(:battery_percentages).where(battery_percentages:
        { status: 2, created_at: start_time..end_time }).count.to_f
      charged = ((charged_value / total.count) * 100).ceil(2)
      undecided = 100.00 - (charged + decline)
      render json: { charged: charged, decline: decline, undecided: undecided }
    end

    private

    def load_dashboard
      @dashboard = Dashboard.find_by(id: params[:id])
      return unless @dashboard.nil?

      render json: { message: "Dashboard with id #{params[:id]} doesn't exists" }, status: :not_found
    end

    def dashboard_params
      params.require(:data).permit(:title, :value)
    end

    def load_account
      @account = AccountBlock::Account.find_by(id: @token.id)
    end
  end
end
