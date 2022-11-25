source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
gem 'hiredis'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'omniauth'

gem 'nokogiri', '>= 1.10.4'

# Markdown
gem 'redcarpet'
# Code heighlight
gem 'rouge'
# Display time to browser local
gem 'local_time'

# paginate
gem 'kaminari'

# Use ActiveStorage variant
gem 'mini_magick', '>= 4.9.4'

# I18n
gem 'http_accept_language'

gem 'dotenv-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Job queue
gem 'sidekiq'

# Static assets packer
gem 'webpacker', '~> 4.0.1'

# Attachment
gem 'carrierwave', '~> 1.3.0'
gem 'carrierwave-aws', '~> 1.3.0', require: false
gem 'carrierwave-google-storage', require: false

# Full text search
gem 'cppjieba_rb'

# ActiveRecord Advisory Lock
gem 'with_advisory_lock'

gem 'rack-attack'

# fix yaml load incompatibility
gem 'psych', '< 4'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # Useful I18n task
  gem 'i18n-tasks', '~> 0.9.21', require: false

  # Fixtures replacement
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Security scanner
  gem 'brakeman', :require => false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Container does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
