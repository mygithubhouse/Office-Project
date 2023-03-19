class AdminUser < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable,
           :recoverable, :rememberable, :validatable
    belongs_to :role, class_name: 'BxBlockRolesPermissions::Role', optional: true

    def authenticate(password)
        valid_password?(password) ? self : nil
    end

    def type
      'AdminUser'
    end
end
