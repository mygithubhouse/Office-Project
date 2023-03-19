module BxBlockRolesPermissions
  class Role < ApplicationRecord
    self.table_name = :roles
    self.primary_key = :id 
    has_many :accounts, class_name: 'AccountBlock::Account', dependent: :destroy
    has_many :admin_users, class_name: 'AdminUser', dependent: :destroy
    has_many :role_permissions
    has_many :permissions, through: :role_permissions
    accepts_nested_attributes_for :permissions,  allow_destroy: true

    validates :name, uniqueness: { message: 'Role already present' }
  end
end
