require 'rails_helper'
RSpec.describe BxBlockCategories::Category, :type => :model do

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:groups)}
end


