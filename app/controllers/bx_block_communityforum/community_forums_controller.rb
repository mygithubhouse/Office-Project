module BxBlockCommunityforum
  class CommunityForumsController < ApplicationController
    before_action :load_community, only: [:show, :update, :destroy, :settings, :taggings]

    def create
      community = CommunityForum.new(community_params.merge(account_id: current_user.id))
      if community.save
        community.join_requests.create(account_id: @current_user.id, followed: true)
        render json: CommunityForumSerializer.new(community, {params: {current_user: current_user}}).serializable_hash,
               status: :created
      else
        render json: ErrorSerializer.new(community).serializable_hash, status: :unprocessable_entity
      end
    end

    def index
      communities = CommunityForum.all
      joined_communities = current_user.community_forums
      my_communities = current_user.my_communities
      unless params[:search].blank?
        communities = communities.search_by(params[:search])
        joined_communities = joined_communities.search_by(params[:search])
        my_communities = my_communities.search_by(params[:search])
      end

      communities_data = Kaminari.paginate_array(
        my_communities + (joined_communities - my_communities) + (communities - joined_communities)
      ).page(index_params[:page]).per(index_params[:per_page])

      render json: {
        communities: CommunityForumSerializer.new(
          communities_data, {params: {current_user: current_user}}
        ).serializable_hash
      }, status: :ok
    end

    def show
      return render json: {message: 'Community does not exist'}, status: :not_found if @community.nil?
      render json: CommunityForumSerializer.new(
        @community, {params: {current_user: current_user}}
      ).serializable_hash, status: :ok
    end

    def settings
      return render json: {message: 'Community does not exist'}, status: :not_found if @community.nil?
      if @community.admin?(current_user)
        if settings_params.values.present?
          if settings_params[:manage_requests] == "true"
            render json: {
              post_request: @community.post_request, join_request: @community.join_request
            }, status: :ok
          elsif settings_params[:blocked_accounts] == "true"
            render json: {
              blocked_accounts:
                AccountBlock::AccountSerializer.new(@community.blocked_accounts).serializable_hash
            }, status: :ok
          elsif settings_params[:joined_accounts] == "true"
            accounts = @community.accounts.where.not(id: current_user.id)
            render json: {
              accounts: AccountBlock::AccountSerializer.new(accounts).serializable_hash,
              count: accounts.count
            }, status: :ok
          else
            render json: {message: "Invalid parameters passed"}, status: :unprocessable_entity
          end
        else
          render json: {
            message: "Need to pass parameters to fetch community settings"
          }, status: :unprocessable_entity
        end
      else
        render json: {message: "Only admin can view the community settings"}, status: :unprocessable_entity
      end
    end

    def update
      return render json: {message: 'Community does not exist'}, status: :not_found if @community.nil?
      if @community.admin?(current_user)
        if @community.update(community_params)
          return render json: CommunityForumSerializer.new(
            @community, {params: {current_user: current_user}}
          ).serializable_hash, status: :ok
        end
      else
        @community.errors.add :community, "Only admin can edit the community"
      end

      render json: ErrorSerializer.new(@community).serializable_hash, status: :unprocessable_entity
    end

    def destroy
      return render json: {message: 'Community does not exist'}, status: :not_found if @community.nil?
      if @community.admin?(current_user)
        if @community.destroy
          return render json: {message: 'Community removed'}, status: :ok
        end
      else
        @community.errors.add :community, "Only admin can delete the community"
      end

      render json: ErrorSerializer.new(@community).serializable_hash, status: :unprocessable_entity
    end

    def taggings
      return render json: {message: 'Community does not exist'}, status: :not_found if @community.nil?
      if @community.joined?(current_user)
        accounts = @community.accounts.regular - [current_user]
        tags = []
        accounts.each do |account|
          tags << {
            id: account.id, full_name: account.full_name, photo: account.photo
          }
        end

        return render json: tags, status: :ok
      else
        @community.errors.add :community, "Please join the community"
      end

      render json: ErrorSerializer.new(@community).serializable_hash, status: :unprocessable_entity
    end

    private

    def community_params
      params.permit \
        :name,
        :description,
        :topics,
        :profile_pic,
        :cover_pic,
        :post_request,
        :join_request
    end

    def settings_params
      params.permit \
        :manage_requests,
        :blocked_accounts,
        :joined_accounts,
        :hidden_posts,
        :rejected_posts,
        :archived_posts,
        :pending_posts
    end

    def index_params
      params.permit(:page, :per_page)
    end

    def load_community
      @community = CommunityForum.find_by(id: params[:id])
    end
  end
end
