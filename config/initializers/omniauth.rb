Rails.application.config.middleware.use OmniAuth::Builder do
end

OmniAuth.config.logger = Rails.logger
