module BxBlockForgotPassword
  class ApplicationRecord < BuilderBase::ApplicationRecord
    self.abstract_class = true

    def generate_password_token!
     self.reset_password_token = generate_token
     self.reset_password_sent_at = Time.now.utc
     save!
    end

    private

    def generate_token
     SecureRandom.hex(10)
    end

  end
end



