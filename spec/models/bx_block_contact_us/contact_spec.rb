require 'rails_helper'      
RSpec.describe BxBlockContactUs::Contact, type: :model do

  subject {BxBlockContactUs::Contact.new(email: "test@gmail.com", description: "test123")}
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:description) }
end

