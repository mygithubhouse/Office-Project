# frozen_string_literal: true

module AccountBlock
  # class groupcreation
  class GroupCreation
    class << self
      def call
        accounts = AccountBlock::Account.all
        accounts.each do |a|
          zipcode = a&.address&.zipcode
          grid = BxBlockStatesCities::Zipcode.find_by(code: zipcode)&.grid_type
          group = if grid.blank?
                    BxBlockAccountGroups::Group.find_by(name: 'Offline')
                  else
                    BxBlockAccountGroups::Group.find_by(name: grid)
                  end
          a.groups << group
          e = Time.zone.now
          s = a.created_at
          month = (e.month - s.month) + 12 * (e.year - s.year)
          a.groups << if (0...4) === month
                        BxBlockAccountGroups::Group.find_by(name: 'NewUser')
                      elsif (4...12) === month
                        BxBlockAccountGroups::Group.find_by(name: 'Experienced')
                      elsif (12..18) === month
                        BxBlockAccountGroups::Group.find_by(name: 'Veteran')
                      else
                        BxBlockAccountGroups::Group.find_by(name: 'SuperUser')
                      end

          a.groups << BxBlockAccountGroups::Group.find_by(name: 'NonTesla')
          if grid.blank?
            a.groups << BxBlockAccountGroups::Group.find_by(name: 'South')
          else
            a.groups << BxBlockAccountGroups::Group.find_by(name: 'North')
          end
        end
      end
    end
  end
end
