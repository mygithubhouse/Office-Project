module AccountBlock
  class AssignBasicGroups
    include Sidekiq::Worker

    def perform(id)
      groups = []
      account = AccountBlock::Account.find_by(id: id)
      zipcode = account&.address&.zipcode
      grid = BxBlockStatesCities::Zipcode.find_by(code: zipcode.to_s)&.grid_type
      e = Time.zone.now
      s = account.created_at
      month = (e.month - s.month) + 12 * (e.year - s.year)
      groups << if (0...4) === month
                  BxBlockAccountGroups::Group.find_by(name: 'NewUser')
                elsif (4...12) === month
                  BxBlockAccountGroups::Group.find_by(name: 'Experienced')
                elsif (12..18) === month
                  BxBlockAccountGroups::Group.find_by(name: 'Veteran')
                else
                  BxBlockAccountGroups::Group.find_by(name: 'SuperUser')
                end
      car_make =  account&.car&.electric_car_make
      if car_make && car_make&.downcase.include?('tesla')
        groups << BxBlockAccountGroups::Group.find_by(name: "Tesla")
      else
        groups << BxBlockAccountGroups::Group.find_by(name: "NonTesla")
      end
      if grid
        groups << BxBlockAccountGroups::Group.find_by(name: grid&.upcase)
        groups << BxBlockAccountGroups::Group.find_by(name: 'North')
      else
        groups << BxBlockAccountGroups::Group.find_by(name: 'Offline')
        groups << BxBlockAccountGroups::Group.find_by(name: 'South')
      end
      groups = groups.compact
      account.groups << groups
    end
  end
end

