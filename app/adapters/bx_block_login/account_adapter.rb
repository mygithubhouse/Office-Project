module BxBlockLogin
  class AccountAdapter
    include Wisper::Publisher

    def login_account(account_params)
      case account_params.type
      when 'sms_account'
        phone = Phonelib.parse(account_params.full_phone_number).sanitized
        account = AccountBlock::SmsAccount.find_by(
          full_phone_number: phone,
          activated: true)
      when 'email_account'
        email = account_params.email.downcase

        account = AccountBlock::EmailAccount
          .where('LOWER(email) = ?', email)
          .where(:activated => true)
          .first
      when 'social_account'
        account = AccountBlock::SocialAccount.find_by(
          email: account_params.email.downcase,
          unique_auth_id: account_params.unique_auth_id,
          activated: true)
      when 'admin_account'
        account = AdminUser.find_by(email: account_params.email.downcase)
      end

      unless account.present?
        broadcast(:account_not_found)
        return
      end

      if account.class != AdminUser && account.blocked
        broadcast(:account_blocked)
        return
      end

      if account.authenticate(account_params.password)
        token, refresh_token = generate_tokens(account.id)
        broadcast(:successful_login, account, token, refresh_token)
      else
        if account.update(sign_in_count: account.sign_in_count + 1)
          if account.sign_in_count > 3
            account.update(blocked: true, blocked_now: Time.now)
            broadcast(:multiple_incorrect_tries, :account)
            return
          end
        end
        broadcast(:failed_login, account)
      end
    end

    def generate_tokens(account_id)
      [
        BuilderJsonWebToken.encode(account_id, 1.day.from_now, token_type: 'login'),
        BuilderJsonWebToken.encode(account_id, 1.year.from_now, token_type: 'refresh')
      ]
    end
  end
end
