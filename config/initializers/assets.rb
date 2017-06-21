
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w( stylesheet.css )
Rails.application.config.assets.precompile += %w( creator_nav.css )
Rails.application.config.assets.precompile += %w( item_nav.css )
Rails.application.config.assets.precompile += %w( menu_nav.css )
Rails.application.config.assets.precompile += %w( registration.js )
Rails.application.config.assets.precompile += %w( user_detail.js )
Rails.application.config.assets.precompile += %w( borrower_seeking.js )
Rails.application.config.assets.precompile += %w( item_search.js )
Rails.application.config.assets.precompile += %w( readonly.js )
Rails.application.config.assets.precompile += %w( existing.js )
Rails.application.config.assets.precompile += %w( new_item.js )
Rails.application.config.assets.precompile += %w( main_user_detail.js )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
