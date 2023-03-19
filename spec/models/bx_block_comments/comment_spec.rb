require 'rails_helper'
RSpec.describe BxBlockComments::Comment, type: :model do
  let(:comment) { create(:comment) }
  context "associations" do
    it { should belong_to(:post) }
  end

  describe 'Instance methods' do
    context '#json_info (used in serializer)' do
      it 'return the hash with object properties' do
        expect(comment.json_info.keys).to match_array(%i(id comment created_at account_id full_name user_name))
      end
    end
  end
end
