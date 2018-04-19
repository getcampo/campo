require 'omniauth/strategies/email'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :email
end
