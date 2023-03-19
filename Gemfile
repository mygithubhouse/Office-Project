source 'https://rubygems.org'
source 'https://gem.fury.io/engineerai'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.6'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
gem "sidekiq-cron"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'dotenv-rails'
  gem 'figaro'
  gem 'redis-rails'
end

group :development, :test do
  gem 'rspec-rails', '5.1.2'
  gem 'rspec-sonarqube-formatter', '1.5.0'
  gem 'simplecov', '0.17'
  gem 'simplecov-json', require: false
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers'
  gem 'factory_bot_rails'
  gem 'webmock'
  gem 'rspec-sidekiq'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'account_block', '0.0.30'
gem 'bx_block_login-3d0582b5', '0.0.10', require: 'bx_block_login'
gem 'bx_block_visual_analytics', '0.1.3'
gem 'bx_block_dashboard-9a14cb77', '0.0.3', require: 'bx_block_dashboard'
gem 'bx_block_share', '0.0.4'
gem 'bx_block_contact_us-6e0a750f', '0.0.3', require: 'bx_block_contact_us'
gem 'bx_block_search', '0.1.5'
gem 'bx_block_profile', '0.0.8'
gem 'bx_block_profile_bio', '0.1.9'
gem 'bx_block_forgot_password-4de8968b', '0.0.6', require: 'bx_block_forgot_password'
gem 'bx_block_account_groups', '0.0.2'
gem 'bx_block_help_centre', '0.0.2'
gem 'bx_block_communityforum', '0.0.3'
gem 'bx_block_comments-568532a5', '0.0.19', require: 'bx_block_comments'
gem 'bx_block_notifications-a22eb801', '0.0.5', require: 'bx_block_notifications'
gem 'bx_block_push_notifications-c0f9e9b7', '0.0.10', require: 'bx_block_push_notifications'
gem 'bx_block_catalogue-0e5da613', '0.0.8', require: 'bx_block_catalogue'
gem 'bx_block_admin', '0.0.15'
gem 'bx_block_notifsettings-296428d4', '0.0.2', require: 'bx_block_notifsettings'
gem 'bx_block_location-99004202', '0.0.4', require: 'bx_block_location'
gem 'bx_block_roles_permissions-c50949d0', '0.0.6', require: 'bx_block_roles_permissions'
gem 'bx_block_custom_form-63cd533b', '0.0.7', require: 'bx_block_custom_form'
gem 'bx_block_navmenu-1cdc25a4', '0.0.3', require: 'bx_block_navmenu'
gem 'builder_base', '0.0.50'
gem 'devise'
gem 'sassc-rails'
gem 'activeadmin'
gem 'active_admin_role'
gem 'activeadmin_json_editor'
gem 'active_admin_datetimepicker'
gem 'activerecord-import'
gem 'sidekiq_alive'
gem 'sidekiq', '~> 6.0'
gem "yabeda-prometheus"    # Base
gem "yabeda-rails"         #API endpoint monitoring
gem "yabeda-http_requests" #External request monitoring
gem "yabeda-puma-plugin"
gem 'yabeda-sidekiq'
gem 'bx_block_cors'
gem 'validates_zipcode'
gem 'city-state'
gem "image_processing"
gem 'activeadmin_addons'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-google-oauth2'
gem 'httparty'
gem 'after_party'
gem 'ckeditor', '4.2.4'
