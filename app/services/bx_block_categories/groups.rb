module BxBlockCategories
  class Groups
    class << self
      def call
        puts("Creating Groups")
        category = ["Experience", "Grid type", "Location", "Manufacturer"]

        category.each do |key|
            group = BxBlockCategories::Category.find_or_create_by(name:key)
            case group.name
            when "Experience"
              self.create_experience_group(group)
            when "Grid type"
              self.create_gridtype_group(group)
            when "Location"
              self.create_location_group(group)
            else
              self.create_manufacturer_group(group)
            end
        end
        BxBlockCategories::Category.find_or_create_by(name: 'Custom')
      end

      def create_experience_group(group)
        BxBlockAccountGroups::Group.find_or_create_by(name:"NewUser", category_id: group.id)
        BxBlockAccountGroups::Group.find_or_create_by(name:"Experienced", category_id: group.id)
        BxBlockAccountGroups::Group.find_or_create_by(name:"Veteran", category_id: group.id)
        BxBlockAccountGroups::Group.find_or_create_by(name:"SuperUser", category_id: group.id)
      end

      def create_gridtype_group(group)
        BxBlockAccountGroups::Group.find_or_create_by(name:"SPP", category_id: group.id)
        BxBlockAccountGroups::Group.find_or_create_by(name:"MISO", category_id: group.id)
        BxBlockAccountGroups::Group.find_or_create_by(name:"ERCOT", category_id: group.id)
        BxBlockAccountGroups::Group.find_or_create_by(name:"Offline", category_id: group.id)
      end

      def create_manufacturer_group(group)
        BxBlockAccountGroups::Group.find_or_create_by(name:"Tesla", category_id: group.id)
        BxBlockAccountGroups::Group.find_or_create_by(name:"NonTesla", category_id: group.id)
      end

      def create_location_group(group)
        BxBlockAccountGroups::Group.find_or_create_by(name:"North", category_id: group.id)
        BxBlockAccountGroups::Group.find_or_create_by(name:"South", category_id: group.id)
      end
    end
  end
end

# BxBlockCategories::Groups.call
