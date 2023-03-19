module AccountBlock
  class SocialAccount < Account
    include Wisper::Publisher

    # validates :email, uniqueness: true, presence: true
    after_validation :set_active

    def set_active
      self.activated = true
    end

     def self.create_user_for_google(data, device_token)
      where(email: data["email"]).first_or_initialize.tap do |user|
      user.password=Devise.friendly_token[0,20]
      user.password_confirmation=user.password
      user.device_token = device_token
      user.role = BxBlockRolesPermissions::Role.find_by(name: "Free")
      user
      end
    end

  end
end
