module BxBlockRolesPermissions
	class RolesController < ApplicationController
		def update_roles
			role = BxBlockRolesPermissions::Role.find_by(name: 'Free')
			AccountBlock::Account.all.each do |account|
		      account.update(role_id: role.id) unless account&.role&.present?
		  end	
		end
	end
end