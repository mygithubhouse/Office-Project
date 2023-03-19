module BxBlockForgotPassword
  class PasswordsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, only: [:create]
    before_action :load_account, only: [:create]
    
    def create
      return render json: {errors: "Invalid Email"}, status: 404 if @account.email != create_params[:email]  
      password_validation = AccountBlock::PasswordValidation.new(create_params[:new_password])
          is_valid = password_validation.valid?
          return render json: {password: @error_message}, status: 404 if @error_message = password_validation.errors.full_messages.first
      if @account.update(:blocked => false, :password => create_params[:new_password], :password_confirmation => create_params[:new_password_confirmation])
         ForgotPasswordMailer
            .with(account: @account, host: request.base_url)
            .forgot_password.deliver
            render json: {message: 'password changed sucessfully done'}, status: 200           
      else
        return render json: {errors: [{ message: @account.errors.full_messages }]}, status: :unprocessable_entity
      end         
    end

    private
    def encode(id)
      BuilderJsonWebToken.encode id
    end

    def create_params
      params.require(:data).permit(:email,:new_password, :new_password_confirmation)
    end

    def load_account
      @account = AccountBlock::Account.find_by(id: @token.account_id)
      if @account.nil?
        render json: {
          message: "Account doesn't exists"
        }, status: :not_found
      end
    end

  end
end

