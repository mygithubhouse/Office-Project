require 'rails_helper'
RSpec.describe BxBlockGamification::UserBadgesController, type: :controller do
  def authenticated_header(user)
    BuilderJsonWebToken.encode(user.id, {account_type: user.type}, 1.year.from_now)
  end
   describe "Get all badges" do
    before do
      @account = create(:account)
      # @battery_percentage = create(:battery_percentage, account: @account)
    end
    context "when pass valid params" do
      it "return List of users." do
        request.headers["token"] = authenticated_header(@account)
         get :index
         expect(response).to have_http_status(200)
      end
    end
  end
end

