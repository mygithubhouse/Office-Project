# frozen_string_literal: true

module BxBlockContactUs
  # This is PrivacyPolicies class for show PrivacyPolicies list
  class PrivacyPoliciesController < ApplicationController
    skip_before_action :validate_json_web_token, only:[:index, :terms_and_condition_list]
    before_action :validate_json_web_token, only:[:term_and_condition_accepted_or_not, :privacy_policy_accepted_or_not]
    before_action :load_account, only: [:term_and_condition_accepted_or_not, :privacy_policy_accepted_or_not]
    
    def index
      @privacy_policy = BxBlockContactUs::PrivacyPolicy.where(policy_type: 1)
      if @privacy_policy.present?
	      render json: PrivacyPolicySerializer.new(@privacy_policy).serializable_hash, status: :ok
      else
        render json: {error: 'Privacy policy not found'}, status: 404
      end
    end
    
    def terms_and_condition_list
      @terms_and_condition = BxBlockContactUs::PrivacyPolicy.where(policy_type: 0)
      if @terms_and_condition.present?
      	render json: PrivacyPolicySerializer.new(@terms_and_condition).serializable_hash, status: :ok
      else
        render json: {error: 'Terms and conditions not found'}, status: 404
      end
    end

    def term_and_condition_accepted_or_not
      @terms_and_condition = BxBlockContactUs::PrivacyPolicy.where(policy_type: 0)
      if @account.term_and_condition_accepted_at
        render json: PrivacyPolicySerializer.new(@terms_and_condition).serializable_hash.merge(is_accepted: true), status: :ok
      else
        render json: PrivacyPolicySerializer.new(@terms_and_condition).serializable_hash.merge(is_accepted: false), status: :ok       
      end
    end

    def privacy_policy_accepted_or_not
      @terms_and_condition = BxBlockContactUs::PrivacyPolicy.where(policy_type: 1)
      if @account.privacy_policy_accepted_at
        render json: PrivacyPolicySerializer.new(@terms_and_condition).serializable_hash.merge(is_accepted: true), status: :ok
      else
        render json: PrivacyPolicySerializer.new(@terms_and_condition).serializable_hash.merge(is_accepted: false), status: :ok       
      end
    end

    private

    def load_account
      @account = AccountBlock::Account.find_by(id: @token.id)
      if @account.nil?
        render json: {
          message: "Account doesn't exists"
        }, status: :not_found
      end
    end

  end
end