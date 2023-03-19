module BxBlockRolesPermissions
  class Permission < ApplicationRecord
    self.table_name = :permissions
    has_many :role_permissions
  end
end
