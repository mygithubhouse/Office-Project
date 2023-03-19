module AccountBlock
  class AddBatteryPercentageWorker
    include Sidekiq::Worker
    require 'httparty'
    BESPOKE_URL = 'http://evdead.com/inventory/getter'
    def perform
      start_time = 1.day.before.beginning_of_day.plus_with_duration(8.hours)
      end_time = 1.day.before.end_of_day.plus_with_duration(8.hours)
      account_ids =  AccountBlock::Account.includes(:battery_percentages).where(battery_percentages: { created_at:start_time..end_time }).ids
      AccountBlock::Account.where.not(id: account_ids).each  {|acc| acc.battery_percentages.create(percent: nil, grade: get_a_grade(acc)) }
      new_user_group = BxBlockAccountGroups::Group.find_by(name: 'NewUser')
      experience_group = BxBlockAccountGroups::Group.find_by(name: 'Experienced')
      veteran_group = BxBlockAccountGroups::Group.find_by(name: 'Veteran')
      super_group = BxBlockAccountGroups::Group.find_by(name: 'SuperUser')
      field = 'created_at < ?'
      new_accounts = new_user_group.accounts.where(field, 4.months.ago)
      experience_accounts = experience_group.accounts.where(field, 12.months.ago)
      veteran_accounts = veteran_group.accounts.where(field, 18.months.ago)
      new_accounts.each do |account|
        account.groups.delete(new_user_group)
        account.groups << experience_group
      end
      experience_accounts.each do |account|
        account.groups.delete(experience_group)
        account.groups << veteran_group
      end
      veteran_accounts.each do |account|
        account.groups.delete(veteran_group)
        account.groups << super_group
      end
    end

    private

    def get_a_grade(acc)
      grid = BxBlockStatesCities::Zipcode.find_by(code: acc&.address&.zipcode&.to_s)&.grid_type
      response = HTTParty.get(BESPOKE_URL)
      return'N/A' unless response.code == 200
      updated_response =  JSON.parse(response)
      arr = if grid
              updated_response.select {|hash| hash['grid'] == grid}.first['week']
            else
              updated_response.first['week'] if grid.nil?
            end
      grade = arr.select {|hash| hash['dow'] == Date.today.strftime("%A") }[0]['grade']
    end
  end
end
