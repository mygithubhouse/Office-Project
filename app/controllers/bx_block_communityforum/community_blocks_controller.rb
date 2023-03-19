module BxBlockCommunityforum
  class CommunityBlocksController < ApplicationController
    before_action :load_community

    def create
      render json: {message: 'Community does not exist'}, status: :not_found if @community.nil?
      if @community.admin?(current_user)
        if (account = AccountBlock::Account.find_by(id: community_params[:account_id].to_i)).present?
          if @community.blocked?(account)
            unblock(account)
          elsif @community.joined?(account) && !@community.admin?(account)
            block(account)
          else
            render json: {message: 'Cannot block this account'}, status: :unprocessable_entity
          end
        else
          render json: {message: "Account doesn't exists"}, status: :unprocessable_entity
        end
      else
        render json: {message: 'Only admin can block an account'}, status: :unprocessable_entity
      end
    end

    private

    def block(account)
      ActiveRecord::Base.transaction do
        @community.join_requests.find_by(account_id: account.id).update(status: 'blocked', context: nil)
        @community.account_blocks.create(account_id: account.id)

        render json: {message: "Account blocked"}, status: :ok
      rescue => e
        render json: {message: e.message}, status: :unprocessable_entity
      end
    end

    def unblock(account)
      if @community.account_blocks.find_by(account: account).destroy
        @community.join_requests.find_by(account_id: account.id).update(status: 'default', context: nil)
        hidden_posts_ids = @community.posts.default.where(account_id: account.id).ids if @community.posts.present?

        render json: {message: "Account unblocked"}, status: :ok
      else
        render json: {message: "Unable to un-block the account"}, status: :unprocessable_entity
      end
    end

    def community_params
      params.permit(:community_forum_id, :account_id)
    end

    def load_community
      @community = BxBlockCommunityforum::CommunityForum.find_by(id: community_params[:community_forum_id])
    end
  end
end
