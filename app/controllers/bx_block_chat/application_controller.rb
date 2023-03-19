module BxBlockChat
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    def not_found
      render json: {"errors" => ["Record not found"]}, status: :not_found
    end

    def current_user
      @current_user = AccountBlock::Account.find(@token.id)
    rescue ActiveRecord::RecordNotFound
      render json: {errors: [
        {message: "Please login again."}
      ]}, status: :unprocessable_entity
    end

    def serialization_options
      {params: {host: request.protocol + request.host_with_port}}
    end

    def chat_message_serialization_options
      {params: {host: request.protocol + request.host_with_port, receiver_id: params[:receiver_id]}}
    end
  end
end
