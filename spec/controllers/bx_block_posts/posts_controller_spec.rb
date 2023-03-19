require 'rails_helper'
RSpec.describe BxBlockPosts::PostsController, type: :controller do

  let(:account) { create(:account) }
  let(:group) { create(:group) }
  let(:post1) { create(:post, account: account) }
  let(:post_list_routes) { '/bx_block_posts/posts/:id/' }

  let(:token) { BuilderJsonWebToken.encode(account.id) }

  describe 'POST #create' do

    let(:create_post_routes) { '/bx_block_posts/posts' }

    context 'when post created' do
      it 'Returns success with vaild params' do
        post :create, params: { token: token, use_routes: create_post_routes, post: { name: "test", body: 'This is demo content', group_id: group.id } }
        expect(JSON.parse(response.body)["meta"]["message"]).to eql("post created succesfully!")
      end
    end

    context 'when invalid token is passed' do
      it 'Returns failed for posts creation' do
        post :create, params: {  use_routes: create_post_routes, token: '12#3',
          post: { name: "test", body: 'sample body', group_id: group.id } }
        expect(JSON.parse(response.body)["errors"].first["token"]).to eql('Invalid token')
      end
    end
  end

  describe 'PUT #update' do

    let(:create_post_routes) { '/bx_block_posts/posts' }

    context 'when passed valid paramas' do
      it 'Returns success created statau' do
        put :update, params: { id: post1.id, token: token, use_routes: create_post_routes, post: { name: "test", body: 'updated demo', group_id: group.id } }
        sample = {"id"=>post1.id, "name"=>"test", "body"=>"updated demo", "created_at"=>"less than a minute ago", "comments"=>[], "comment_count"=>0}
        keys = ['id', 'name', 'body', 'created_at', 'comments', 'comment_count', 'account_id', 'full_name', 'account_group', 'post_group', 'user_name']
        expect(JSON.parse(response.body)['data']['attributes']).to include(sample)
        expect(JSON.parse(response.body)['data']['attributes'].keys).to match_array(keys)
      end
    end

    context 'when token passed is invalid' do
      it 'Returns failed for posts updation' do
        put :update, params: { id: post1.id, use_routes: create_post_routes, token: '12#3',
          post: { name: "test", body: 'content body', group_id: group.id } }
        expect(JSON.parse(response.body)["errors"].first["token"]).to eql('Invalid token')
      end
    end
  end

  describe 'GET index' do

    context "when group_id is present for post list" do
      before do
        post1
      end
      it 'Returns success with vaild posts' do
        get :index, params: { token: token, use_routes: post_list_routes, group_id: [ group.id, group.id ] }
        expect(response).to have_http_status(200)
      end
    end

    context "when post is not present" do
      it 'Returns failed for post list' do
        get :index, params: { use_routes: post_list_routes, token: token, group_id: [ group.id, group.id ] }
        expect(JSON.parse(response.body)["data"]["message"]).to eql('No post list available')
      end
    end
  end

  describe 'GET show' do

    context "when post is present" do
      it 'Returns success with vaild posts' do
        post1
        get :show, params: { token: token, use_routes: post_list_routes, id: post1.id }
        expect(response).to have_http_status(200)
      end
    end

    context "when post is not present" do
      it 'Returns not found' do
        get :show, params: { use_routes: post_list_routes, token: token, id: 999 }
        expect(JSON.parse(response.body)['errors']).to match_array([{"Post"=>"Not found"}])
      end
    end
  end

   describe 'DELETE #destroy' do

    context "when post is present" do
      it 'Returns success with vaild status' do
        post1
        delete :destroy, params: { token: token, use_routes: post_list_routes, id: post1.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #add_comment' do
    let(:post1) { create(:post, account: account) }


    context 'when post is not found for add_comment' do
      it 'Returns failed post not found' do
        post :add_comment, params: { id: '12#4', token: token, comment: {comment: "test comment"}}
        expect(response).to have_http_status(404)
      end
    end

    context 'when post is present for add_comment' do
      it 'Returns success for add_comment' do
        post :add_comment, params: { id: post1.id, token: token, comment: { comment: "test"} }
        expect(JSON.parse(response.body)["meta"]["message"]).to eql("comment created succesfully!")
      end
    end

    context 'when invalid token not found' do
      it 'Returns failed with invalid token' do
        post :add_comment, params: { id: post1.id, id: post1.id, token: '234$', comment: { comment: "test" } }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE #delete_comment' do
    let(:comment) { create(:comment, account: account, post: post1) }

    context 'when comment is present for delete_comment' do
      it 'Returns success for delete_comment' do
        delete :delete_comment, params: { id: post1.id, comment_id: comment.id, token: token, comment: {comment: "test demo comment"}}
        expect(JSON.parse(response.body)["message"]).to eql('Deleted succesfully!')
      end
    end

    context 'when comment not found for delete_comment' do
      it 'Returns failed for delete_comment' do
        delete :delete_comment, params: { id: post1.id, comment_id: '124', token: token, comment: {comment: "my comment"}}
        expect(response).to have_http_status(404)
      end
    end
  end
end
