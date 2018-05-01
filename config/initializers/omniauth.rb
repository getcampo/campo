Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    require 'omniauth/strategies/test'
    provider :test
  end
end

OmniAuth.config.logger = Rails.logger
