AUTH_PROVIDERS = ENV['AUTH_PROVIDERS'].split(',').map(&:strip)

Rails.application.config.middleware.use OmniAuth::Builder do
  if AUTH_PROVIDERS.include?('test')
    require 'omniauth/strategies/test'
    provider :test
  end
end

OmniAuth.config.logger = Rails.logger
