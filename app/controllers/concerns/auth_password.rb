module AuthPassword
  extend ActiveSupport::Concern

  def require_auth_password_enabled
    redirect_to sign_in_path, alert: 'Password auth is disabled.' unless AUTH_PROVIDERS.include?('password')
  end
end
