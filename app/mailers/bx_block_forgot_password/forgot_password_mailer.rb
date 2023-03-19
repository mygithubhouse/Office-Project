module BxBlockForgotPassword
  class ForgotPasswordMailer < ApplicationMailer
    def forgot_password
      @account = params[:account]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      mail(
          to: @account.email,
          from: 'windeverest',
          subject: 'Password Changed') do |format|
        format.html { render 'forgot_password' }
      end
    end
  end
end
