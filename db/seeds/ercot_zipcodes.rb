require 'csv'

csv_text = File.read(Rails.root.join('db' , 'seed_files' , 'us', 'ercot_zip_053122b.csv' ))
csv = CSV.parse(csv_text, :headers => false ,:encoding =>'ISO-8859-1')

us = BxBlockStatesCities::CountryList.find_by!(alpha_code: "US")

state_codes = {:AK=>"Alaska", :AL=>"Alabama", :AR=>"Arkansas", :AZ=>"Arizona", :CA=>"California", :CO=>"Colorado", :CT=>"Connecticut", :DC=>"District of Columbia", :DE=>"Delaware", :FL=>"Florida", :GA=>"Georgia", :HI=>"Hawaii", :IA=>"Iowa", :ID=>"Idaho", :IL=>"Illinois", :IN=>"Indiana", :KS=>"Kansas", :KY=>"Kentucky", :LA=>"Louisiana", :MA=>"Massachusetts", :MD=>"Maryland", :ME=>"Maine", :MI=>"Michigan", :MN=>"Minnesota", :MO=>"Missouri", :MS=>"Mississippi", :MT=>"Montana", :NC=>"North Carolina", :ND=>"North Dakota", :NE=>"Nebraska", :NH=>"New Hampshire", :NJ=>"New Jersey", :NM=>"New Mexico", :NV=>"Nevada", :NY=>"New York", :OH=>"Ohio", :OK=>"Oklahoma", :OR=>"Oregon", :PA=>"Pennsylvania", :RI=>"Rhode Island", :SC=>"South Carolina", :SD=>"South Dakota", :TN=>"Tennessee", :TX=>"Texas", :UT=>"Utah", :VA=>"Virginia", :VT=>"Vermont", :WA=>"Washington", :WI=>"Wisconsin", :WV=>"West Virginia", :WY=>"Wyoming"}

import_zipcodes = []
csv.each do |row|
	zip, _name, state_code, city_name = row
	state = BxBlockStatesCities::State.find_or_initialize_by(country_list_id: us.id, name: state_codes[state_code.to_sym], alpha_code: state_code, country_code: "US")
	state.save!
	city =  BxBlockStatesCities::City.find_or_initialize_by(name: city_name, state_id: state.id)
	city.save!
	zipcode =  BxBlockStatesCities::Zipcode.find_or_initialize_by(code: zip, grid_type: 'ERCOT', city_id: city.id)
	import_zipcodes << zipcode
end
BxBlockStatesCities::Zipcode.import import_zipcodes, ignore: true, raise_error: false

# import_zipcodes = []
# csv.each do |row|
# 	zip, _name, state_code, city_name = row
# 	state = BxBlockStatesCities::State.new(country_list_id: us.id, name: state_codes[state_code.to_sym], alpha_code: state_code, country_code: 'US')
# 	city = state.cities.build(name: city_name, state_code: state_code)
# 	zipc_code = city.zipcodes.build(code: zip, grid_type: 'ERCOT')
# 	import_states << state
# end
# BxBlockStatesCities::State.import import_states, recursive: true, validate_uniqueness: true, , on_duplicate_key_update: [:title], raise_error: false
# puts "invalid states are #{BxBlockStatesCities::State.all.reject{ |a| a.valid? }.count}............"
# puts "invalid city are #{BxBlockStatesCities::City.all.reject{ |a| a.valid? }.count}..............."
# puts "invalid zipcodes are #{BxBlockStatesCities::Zipcode.all.reject{ |a| a.valid? }.count}........."