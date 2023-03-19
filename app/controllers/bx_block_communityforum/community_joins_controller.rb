module BxBlockCommunityforum
  class CommunityJoinsController < ApplicationController
    before_action :load_community, except: [:accept, :reject]
    before_action :load_request, only: [:accept, :reject]

    def index
      if @community.nil?
        render json: { message: 'Community does not exist' }, status: :not_found
      end
      if @community.admin?(current_user)
        pending_requests = @community.join_requests.pending
        render json: CommunityJoinSerializer.new(pending_requests).serializable_hash, status: :ok
      else
        render json: { message: 'Only admin can view pending requests' }, status: :unprocessable_entity
      end
    end

    def create
      if @community.nil?
        render json: { message: 'Community does not exist' }, status: :not_found and return
      end

      if @community.joined?(current_user)
        render json: {
          message: 'Admin cannot disenroll from the community'
        }, status: :unprocessable_entity and return if @community.admin?(current_user)
        @community.join_requests.find_by(account_id: @current_user.id).update(status: 'removed', context: nil)

        render json: { message: 'Disenrolled from the community' }, status: :created
      else
        render json: { message: 'Cannot join this community. Account is blocked' },
          status: :unprocessable_entity and return if @community.blocked?(current_user)

        join_request = @community.join_requests.find_or_initialize_by(account: @current_user)
        message = 'Joined the community'

        if @community.join_request
          if join_request.pending?
            join_request.status = 'removed'
            join_request.context = nil
            message = 'Joining request removed'
          else
            join_request.status = 'pending'
            join_request.context = nil
            message = 'Joining request sent'
          end
        end

        if join_request.save
          render json: { message: message }, status: :created
        else
          render json: { message: 'Unable to send request' }, status: :unprocessable_entity
        end
      end
    end

    def accept
      if @request.present?
        if @request.community_forum.admin?(current_user)
          @request.update(status: 'default', context: nil)
          render json: { message: 'Request accepted' }, status: :ok
        else
          render json: { message: 'Only admin can accept the request' }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Request not found' }, status: :not_found
      end
    end

    def reject
      if @request.present?
        if @request.community_forum.admin?(current_user)
          if reject_request_params[:message].blank?
            render json: {
              message: "Need a reason for rejecting joining request"
            }, status: :unprocessable_entity and return
          else
            @request.context = reject_request_params[:message]
            @request.status = 'rejected'
          end

          if @request.save
            render json: { message: 'Request rejected' }, status: :ok
          else
            render json: { message: "Couldn't reject the request" }, status: :unprocessable_entity
          end
        else
          render json: { message: 'Only admin can reject the request' }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Request not found' }, status: :not_found
      end
    end

    def follow
      if @community.nil?
        render json: { message: 'Community does not exist' }, status: :not_found
      end

      if @community.joined?(current_user)
        com_join = @community.join_requests.find_by(account_id: @current_user.id)
        if com_join.followed
          com_join.update(followed: false)
          render json: { message: 'Unfollowed the community' }, status: :ok
        else
          com_join.update(followed: true)
          render json: { message: 'Followed the community' }, status: :ok
        end
      else
        render json: { message: 'Join the community before following' }, status: :unprocessable_entity
      end
    end

    private

    def community_params
      params.permit(:community_forum_id)
    end

    def load_community
      @community = BxBlockCommunityforum::CommunityForum.find_by(id: community_params[:community_forum_id])
    end

    def load_request
      @request = CommunityJoin.find_by(id: params[:id], status: 'pending')
    end

    def reject_request_params
      params.permit(:message)
    end
  end
end
