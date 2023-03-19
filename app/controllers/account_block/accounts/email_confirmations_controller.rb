# frozen_string_literal: true

module AccountBlock
  module Accounts
    class EmailConfirmationsController < ApplicationController
      include BuilderJsonWebToken::JsonWebTokenValidation

      before_action :validate_json_web_token

      def show
        begin
          @account = EmailAccount.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors:
            {message: 'Account Not Found'}
          }, status: :unprocessable_entity
        end
        @account.update :activated => true
        redirect_to ENV['FE_URL']
      end
    end
  end
end
