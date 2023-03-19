module BxBlockNotifsettings
	class EasyModeSerializer < BuilderBase::BaseSerializer
		attributes *[
		            :nights_ahead,
		            :easy_prompt_time,
		            :second_easy_prompt_time,
		            :active]

		
     attributes :easy_prompt_time do |easy_mode|
     	format_time easy_mode.easy_prompt_time
     end

     attributes :second_easy_prompt_time do |easy_mode|
     	format_time easy_mode.second_easy_prompt_time
     end

        private

        def self.format_time(time)
            time.strftime("%I:%M %P") rescue ""
        end

	end
end
