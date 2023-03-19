# frozen_string_literal: true
module BxBlockLogin
  require 'httparty'
  require 'json'
  class SocialLoginsController < ApplicationController
  include BuilderJsonWebToken::JsonWebTokenValidation
  include HTTParty

    def get_authorization
      return render json: {errors: 'Param missing'}, status: 400 if params['device_token'].blank?
      url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{params["token"]}"
      @response = HTTParty.get(url)
      return render json: { errors: @response.parsed_response }, status: 422 unless @response.success?
      @user = AccountBlock::SocialAccount.create_user_for_google(@response.parsed_response, params['device_token'])
      return render json: { errors: @user&.errors }, status: 422 unless @user.save
      token = BuilderJsonWebToken.encode(@user.id)
      render json: "AccountBlock::SocialAccountSerializer".constantize.new(@user, meta: {token: token}).serializable_hash, status: :created
    end
  end
end
