require 'net/http'
require 'uri'
require 'twitter'

module BxBlockShare
  class ShareController < ApplicationController
    def twitter
      path = twitter_params[:url]
      twit_path = "https://twitter.com/intent/tweet?text=#{path}"
      render json: {message: twit_path}, status: :ok
    end

    def create
      share = ::BxBlockShare::Share.create!(share_params.merge!({account_id: current_user.id}))
      if share.persisted?
        share.upload_documents(params[:data][:documents]) if params[:data][:documents].present?
      end

      render json: ShareSerializer.new(share, meta: {message: 'Share.'
         }).serializable_hash, status: :ok

    end

    def index
      shared = ::BxBlockShare::Share
                  .where('shared_to_id = :search or account_id = :search', search: current_user.id)
                  .order(created_at: :desc)
      render json: ShareSerializer.new(
        shared, meta: { message: 'Share.' }
      ).serializable_hash, status: :ok
    end

    def shared_with_me
      shared = ::BxBlockShare::Share
                 .where('shared_to_id = :search', search: current_user.id)
                 .order(created_at: :desc)
      render json: ShareSerializer.new(
        shared, meta: { message: 'Share.' }
      ).serializable_hash, status: :ok
    end

    private

    def twitter_params
      params.permit(:url)
    end

    def share_params
      params
        .require(:data)
        .permit( :shared_to_id, :post_id )
    end
  end
end
