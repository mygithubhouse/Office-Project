module BxBlockLogin
  class LoginsController < ApplicationController
    def create
      case params[:data][:type] #### rescue invalid API format
      when 'sms_account', 'email_account', 'social_account', 'admin_account'
        account = OpenStruct.new(jsonapi_deserialize(params))
        account.type = params[:data][:type]


        output = AccountAdapter.new

        output.on(:account_not_found) do |account|
          render json: {
            errors: [{
              failed_login: 'Account not found, or not activated',
            }],
          }, status: :unprocessable_entity
        end

        output.on(:failed_login) do |account|
          render json: {
            errors: [{
              failed_login: 'Password is incorrect',
            }],
          }, status: 422
        end

        output.on(:multiple_incorrect_tries) do |account|
          render json: {message: 'Your Account has been block! You need to change your password'},status: 422
        end

        output.on(:account_blocked) do |account|
          render json: {message: 'Your Account has been blocked. Please unblock it first'},status: 422
        end

        output.on(:successful_login) do |account, token, refresh_token|
          return render json: { token: token } if account.class == AdminUser
          type = account.type
          render json: "AccountBlock::#{type}Serializer".constantize.new(account, meta: {
            token: token,
          }).serializable_hash,status: 200
          account.update(blocked_now: nil, sign_in_count: 0, device_token: params[:data][:device_token])
        end
        output.login_account(account)
      else
        render json: {
          errors: [{
            account: 'Invalid Account Type',
          }],
        }, status: :unprocessable_entity
      end
    end
  end
end

