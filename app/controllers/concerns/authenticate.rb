module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  private

  def authenticate
    if cookies[:auth_token]
      unless Current.user = User.find_by(auth_token: cookies[:auth_token])
        sign_out
      end
    end
  end

  def sign_in(user)
    cookies[:auth_token] = {
      value: user.auth_token,
      expires: 1.month,
      httponly: true
    }
  end

  def sign_out
    cookies[:auth_token] = nil
  end

  def set_identity(identity)
    session[:identity_id] = identity.id
  end

  def load_identity
    if session[:identity_id]
      unless Current.identity = Identity.find_by(id: session[:identity_id])
        session[:identity_id] = nil
      end
    end
  end
end
