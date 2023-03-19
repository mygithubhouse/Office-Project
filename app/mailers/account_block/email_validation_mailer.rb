module AccountBlock
  class EmailValidationMailer < ApplicationMailer
    def activation_email
      @account = params[:account]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      @url = "#{@host}/account_block/accounts/email_confirmations/#{@account.id}?token=#{params[:token]}"
      

      mail(
          to: @account.email,
          from: 'windeverest',
          subject: 'Account activation') do |format|
        format.html { render 'activation_email' }
      end
    end

    
    def block_email
      @account = params[:account]    
      mail(
          to: @account.email,
          from: 'windeverest',
          subject: 'Block Account Mail') do |format|
        format.html { render 'block_email' }
        end
    end
    private
    def encoded_token
      BuilderJsonWebToken.encode(@account.id, 10.minutes.from_now)
    end
  end
end
  