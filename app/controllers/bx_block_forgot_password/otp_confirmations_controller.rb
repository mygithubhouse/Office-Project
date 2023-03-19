module BxBlockForgotPassword
  class OtpConfirmationsController < ApplicationController
     include BuilderJsonWebToken::JsonWebTokenValidation
     before_action :validate_json_web_token, only: [:create]
    def create
      if create_params[:otp_code].present?
        begin
          @new_generated_token = BuilderJsonWebToken.encode(@token.id, 15.minutes.from_now, account_id: @token.account_id)
          
        rescue JWT::ExpiredSignature
          return render json: {
            errors: [{
              pin: 'OTP has expired, please request a new one.',
            }],
          }, status: :unauthorized
        rescue JWT::DecodeError => e
          return render json: {
            errors: [{
              token: 'Invalid token',
            }],
          }, status: :bad_request
        end

        begin
          otp  = @token.type.constantize.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {
            errors: [{
              otp: 'Token invalid',
            }],
          }, status: :unprocessable_entity
        end

        if otp.pin == create_params[:otp_code].to_i
          otp.activated = true
          otp.save
          render json: {
            messages: [{
              otp: 'OTP validation success',
              token: @new_generated_token
            }],
          }, status: :created
        else
          return render json: {
            errors: [{
              otp: 'Invalid OTP code',
            }],
          }, status: :unprocessable_entity
        end
      else
        return render json: {
          errors: [{
            otp: 'OTP code is required',
          }],
        }, status: :unprocessable_entity
      end
    end

    private

    def get_account_id
      AccountBlock::EmailOtp.find_by(id: @token.id)&.id
    end
    def create_params
     params.require(:data).permit(:otp_code)
    end
  end
end
