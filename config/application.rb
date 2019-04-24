require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if ENV['ENV_FILE'].present?
  Dotenv.load(ENV['ENV_FILE'])
end

module Campo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.active_record.schema_format = :sql

    # Use redis cache store in all env
    config.cache_store = :redis_cache_store, {
      url: ENV["REDIS_URL"],
      namespace: 'cache',
      expires_in: 1.day
    }

    config.action_mailer.default_url_options = { host: ENV['HOST'] }
    # disable field_with_error class
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      html_tag
    end

    config.active_storage.service = ENV['STORAGE_SERVICE']

    config.active_job.queue_adapter = :sidekiq

    config.i18n.available_locales = %w(en zh-CN)

    # Disable unnessary generator
    config.generators do |generate|
      generate.helper false
      generate.assets false
      generate.view_specs false
    end
  end
end
