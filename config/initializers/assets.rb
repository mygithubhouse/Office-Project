# Be sure to restart your server when you modify this file.

Rails.application.config do |assets|
  # Version of your assets, change this if you want to expire all your assets.
  assets.version = '1.0'

  # Add additional assets to the asset load path.
  # Rails.application.config.assets.paths << Emoji.images_path
  # Add Yarn node_modules folder to the asset load path.
  assets.paths << Rails.root.join('node_modules')

  # For ckeditor
  assets.precompile += %w[ckeditor/*]
end

# Rails.application.config.assets.precompile += %w( admin.js admin.css )
