module BxBlockNotifsettings
	  class VacationModeSettingSerializer < BuilderBase::BaseSerializer
	  		attributes :vacation_begin, :vacation_end, :default_commitment, :active

	  	attributes :vacation_begin do |vacation_mode_setting|
     		format_date vacation_mode_setting.vacation_begin
     	end

     	attributes :vacation_end do |vacation_mode_setting|
     		format_date vacation_mode_setting.vacation_end
     	end

     	private

     	def self.format_date(date)
     		date.strftime("%D") rescue ""
     	end
	  end
end



