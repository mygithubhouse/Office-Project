module BxBlockGamification
  class UserBadgesController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, only: %i[index]
    before_action :load_account

    def index
      badges = @account.user_badges.order(badge_id: :asc)
      render json: BxBlockGamification::UserBadgesSerializer.new(
        badges,serialization_options
        ).serializable_hash,status: :ok
    end

    private

    def load_account
      @account = AccountBlock::Account.find_by(id: @token.id)
      return unless @account.nil?

      render json: {
        message: "Account doesn't exists"
      }, status: :not_found
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end
  end
end