module BxBlockForgotPassword
  class OtpsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    
    def create    
      puts " - params = #{params}"
      json_params = jsonapi_deserialize(params)
      
      if json_params['email'].present? 
        account = AccountBlock::EmailAccount
          .where(
            "LOWER(email) = ? AND activated = ?",
            json_params['email'].downcase,
            true
          ).first
        return render json: {
          errors: [{
            account: 'Account not found',
          }],
        }, status: :not_found if account.nil?

        email_otp = AccountBlock::EmailOtp.new(jsonapi_deserialize(params))
        if account.blocked && (account.blocked_now > 8.hours.before) 
          render json: {
            errors: "You can't generate Otp for 8 hours",
          }, status: :unprocessable_entity
        else
          email_otp.save
          send_email_for email_otp
          render json: serialized_email_otp(email_otp, account.id),
            status: :created
        end
      end
    end

    private

    def send_email_for(otp_record)
      EmailOtpMailer
        .with(otp: otp_record, host: request.base_url)
        .otp_email.deliver
    end

    def serialized_email_otp(email_otp, account_id)
      token = token_for(email_otp, account_id)
      EmailOtpSerializer.new(
        email_otp,
        meta: { token: token }
      ).serializable_hash
    end

    def token_for(otp_record, account_id)
      BuilderJsonWebToken.encode(
        otp_record.id,
        15.minutes.from_now,
        type: otp_record.class,
        account_id: account_id
      )      
    end
  end
end


