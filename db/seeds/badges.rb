require 'csv'
require 'open-uri'

csv_text = File.read(Rails.root.join('db' , 'seed_files' , 'badges', 'badges.csv' ))
csv = CSV.parse(csv_text, :headers => true, :encoding =>'ISO-8859-1')

csv.each do |row|
  badges = BxBlockGamification::Badge.find_or_initialize_by(name: row["Name"])
  badges.update(title: row["Title"], description: row["Description"])
  image_file_name  = row["LockedImage"].split('/')[-1]
  badges.locked_image.attach(io: File.open(File.join(Rails.root,row["LockedImage"])), filename: image_file_name, content_type: 'image/png')
  badges.unlocked_image.attach(io: File.open(File.join(Rails.root,row["UnlockedImage"])), filename: image_file_name, content_type: 'image/png')
  badges.save!
end
AccountBlock::Account.all.each do |acc |
  BxBlockGamification::Badge.first(14).each do| badge |
	BxBlockGamification::UserBadge.find_or_create_by!(badge_id: badge.id , account_id: acc.id)
  end
end