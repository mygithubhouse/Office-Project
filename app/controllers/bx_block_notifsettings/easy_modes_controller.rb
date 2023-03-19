module BxBlockNotifsettings
	class EasyModesController < ApplicationController
		def create
			if current_user.role_id == premium_role_id
				easy_mode =  BxBlockNotifsettings::EasyMode.new(easy_modes_params.merge(account_id: current_user.id))
      			if easy_mode.save
       				render json: ::BxBlockNotifsettings::EasyModeSerializer.new(easy_mode).serializable_hash, status: :created
     	 		else
       		 		render json: { errors: format_activerecord_errors(easy_mode.errors) },status: :unprocessable_entity
      			end
      		else
      			not_authorize
      		end
		end
		def index
			if current_user.role_id == premium_role_id
				easy_mode = current_user.easy_mode
      			render json: ::BxBlockNotifsettings::EasyModeSerializer.new(easy_mode).serializable_hash, status: :ok
      		else
      			not_authorize
      		end
		end
		def easy_modes_params
      	  params.require(:data).require(:easy_modes).permit(:nights_ahead, :easy_prompt_time, :second_easy_prompt_time, :active)
    	end

    	def not_authorize
    		render json: { errors: "User is not premium!" },
               status: :unprocessable_entity
      		
      	end

      	def premium_role_id
      		BxBlockRolesPermissions::Role.find_by(name: "Subscription").id rescue nil
      	end
	end
end
