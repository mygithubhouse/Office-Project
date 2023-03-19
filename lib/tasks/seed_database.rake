namespace :seed_database do
  desc "Creating Cities"
  task create_cities: :environment do
  	# creating Cities
	puts("Creating Cities")
	BxBlockStatesCities::State.all.each do |state|
	  constant_city = "CITY_#{state.alpha_code}_#{state.country_code}" 
	  constant = eval(constant_city)
	  constant.each do |city|
	    begin
	      state.cities.find_or_create_by(name: city, state_code: state.alpha_code)
	    rescue Exception => e
	      puts("Error in creating cities #{e} due to #{e.message}")
	      next
	    end
	  end
	end
	puts "data seeded successfully"
  end
end
