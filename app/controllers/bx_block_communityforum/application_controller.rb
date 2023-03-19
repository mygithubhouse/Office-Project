module BxBlockCommunityforum
  class ApplicationController < BuilderBase::ApplicationController
    include ActionController::RequestForgeryProtection
    include BuilderJsonWebToken::JsonWebTokenValidation
    protect_from_forgery with: :exception

    before_action :validate_json_web_token
    skip_before_action :verify_authenticity_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    def current_user
      begin
        if @token.token_type == 'login'
          @current_user = AccountBlock::Account.find(@token.id)
        else
          raise ActiveRecord::RecordNotFound
        end
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
            {message: 'Please login again.'},
        ]}, status: :unprocessable_entity
      end
    end

    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end
  end
end
