require 'rails_helper'
RSpec.describe BxBlockAccountGroups::GroupsController, type: :controller do

  let(:account) { create(:account) }
  let(:category) { create(:category) }
  let(:token) { BuilderJsonWebToken.encode(account.id) }

  describe 'POST create' do
    let(:create_group_routes) { 'bx_block_account_groups/groups' }

    context 'when group is present for group creation' do
      it 'Returns success for group' do
        post :create, params: { token: token, use_routes: create_group_routes, group: { name: "test" }, category_id: category.id }
        expect(JSON.parse(response.body)["meta"]["message"]).to eql("Group successfully created")
      end
    end

    context 'when invalid token not found' do
      it 'Returns failed for group creation' do
        post :create, params: { token: '12#3', group: { name: "test" } }
        expect(JSON.parse(response.body)["errors"].first["token"]).to eql('Invalid token')
      end
    end
  end

  describe 'GET index' do

    let(:group_list_routes) { 'bx_block_account_groups/groups' }

    context "when group_id is present for post list" do
      it 'Returns success with vaild posts' do
        get :index, params: { token: token, use_routes: group_list_routes }
        expect(response).to have_http_status(200)
      end
    end

    context "With search params" do
      it 'Returns relevant groups' do
        get :index, params: { token: token, use_routes: group_list_routes, search: 'Grid' }
        expect(JSON.parse(response.body)['data'].count).to eq(5)
      end
    end

    context "With for_chat params" do
      it 'Returns only selected groups' do
        get :index, params: { token: token, use_routes: group_list_routes, for_chat: 'true' }
        expect(JSON.parse(response.body)['data'].count).to eq(4)
      end
    end

    context 'when invalid token not found' do
      it 'Returns failed for group creation' do
        post :create, params: { token: '12#3', use_routes: group_list_routes, params: { search: 'abc' } }
        expect(JSON.parse(response.body)["errors"].first["token"]).to eql('Invalid token')
      end
    end
  end

  describe 'DELETE destroy' do
    let(:group) { create(:group) }
    let(:group_routes) { '/bx_block_account_groups/groups/:id' }

    context 'when group is present for delete group' do
      it 'Returns success for delete group' do
        delete :destroy, params: { id: group.id, token: token, use_routes: group_routes }
        expect(JSON.parse(response.body)["message"]).to eql('Deleted successfully!')
      end
    end

    context 'when group not found for destroy' do
      it 'Returns failed for destroy' do
        delete :destroy, params: { id: '1', token: token, use_routes: group_routes }
        expect(JSON.parse(response.body)['errors']['base']).to match_array(["Basic group can't be destroyed"])
      end
    end
  end

  describe 'GET show' do
    let(:group) { build_stubbed(:group) }
    let(:group_routes) { '/bx_block_account_groups/groups/:id' }

    context 'when group not exist' do
      it 'Returns not found' do
        get :show, params: { id: group.id, token: token, use_routes: group_routes }
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['errors']).to match_array([{"message"=>"Group not found"}])
      end
    end

    context 'when group exist' do
      it 'Returns success response' do
        get :show, params: { id: '1', token: token, use_routes: group_routes }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['attributes']).to include({"name"=>"NewUser"})
      end
    end
  end

  describe 'POST join_group' do
    let(:group) { create(:group) }

    context 'when account is already a linked to group' do
      before do
        account.groups << BxBlockAccountGroups::Group.first
      end
      it 'Returns errors not acceptable' do
        post :join_group, params: { id: 1, token: token }
        expect(response).to have_http_status(406)
        expect(JSON.parse(response.body)['errors']).to eq("Already a part of group")
      end
    end

    context 'when account is not linked' do
      it 'Returns success with group data' do
        post :join_group, params: { id: group.id, token: token }
        expect(response).to have_http_status(200)
        sample = {'name'=> group.name, 'members' =>[{ 'id' => account.id, 'email' => account.email, 'name' => account.name }] }
        expect(JSON.parse(response.body)['data']['attributes']).to eq(sample)
      end
    end
  end

  describe 'DELETE leave_group' do
    let(:group) { create(:group) }

    context 'when account is already a linked to group' do
      before do
        account.groups << BxBlockAccountGroups::Group.first
      end
      it 'Returns success by ulinking account ' do
        delete :leave_group, params: { id: 1, token: token }
        expect(response).to have_http_status(200)
        expect(account.groups.pluck(:name)).not_to include('NewUser')
      end
    end

    context 'when account is not linked' do
      it 'Returns errors not acceptable' do
        delete :leave_group, params: { id: group.id, token: token }
        expect(response).to have_http_status(406)
        expect(JSON.parse(response.body)['errors']).to eq("You are not a member of this group")
      end
    end
  end
end
