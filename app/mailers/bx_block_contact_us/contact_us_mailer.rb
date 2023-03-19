module BxBlockContactUs
  class ContactUsMailer < ApplicationMailer

    def revert
      account=params[:email]
      mail(
          to: account,
          from: 'windeverest',
          subject: 'Response from windeverest') do |format|
        format.html { render 'revert' }
      end
    end

    def contact_us
      account=params[:account]
      mail(
          to: account.email,
          from: 'windeverest',
          subject: 'Do not reply') do |format|
        format.html { render 'contact_us' }
      end
    end
  end

end
