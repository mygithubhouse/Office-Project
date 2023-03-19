require 'rails_helper'
RSpec.describe BxBlockCategories::Groups, type: :services do
  subject { described_class.call }

  context '#Call' do
    before do
      subject
    end

    it "create respective categories" do
      category_list = BxBlockCategories::Category
      expect(category_list.count).to eql(5)
      categories = ["Experience", "Grid type", "Location", "Manufacturer", "Custom"]
      expect(category_list.pluck(:name)).to match_array(categories)
    end

    it "create respective subcategories of categories group" do
      group_list = BxBlockAccountGroups::Group
      expect(group_list.count).to eql(12)
      categories_subgroups = ["NewUser", "Experienced", "Veteran", "SuperUser", "SPP", "MISO", "ERCOT", "Offline", "North", "South", "Tesla", "NonTesla"]
      expect(group_list.pluck(:name)).to match_array(categories_subgroups)
    end
  end
end
