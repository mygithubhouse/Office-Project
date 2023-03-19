module BxBlockNotifsettings
	class VacationModeSettingsController < ApplicationController
		def create
			vacation_mode_setting =  BxBlockNotifsettings::VacationModeSetting.new(vacation_mode_settings_params.merge(account_id: current_user.id, vacation_begin: vacation_begin, vacation_end: vacation_end))
        	if vacation_mode_setting.save
            render json: ::BxBlockNotifsettings::VacationModeSettingSerializer.new(vacation_mode_setting).serializable_hash, status: :created
        	else
            render json: { errors: format_activerecord_errors(vacation_mode_setting.errors) },
               status: :unprocessable_entity
        	end
		end

		def index
			 vacation_mode_setting = current_user.vacation_mode_setting
             render json: ::BxBlockNotifsettings::VacationModeSettingSerializer.new(vacation_mode_setting).serializable_hash, status: :ok
		end
			def vacation_mode_settings_params
			 params.require(:data).require(:vacation_mode_settings).permit(:vacation_end, :default_commitment, :active)
			end

		private

		def vacation_begin
			parse_date params[:data][:vacation_mode_settings][:vacation_begin] rescue nil
		end

		def vacation_end
			parse_date params[:data][:vacation_mode_settings][:vacation_end] rescue nil
		end

		def parse_date(date)
			date = date.split('/')
			Date.parse("#{date[1]}-#{date[0]}-#{date[2]}")
		end
	end
end