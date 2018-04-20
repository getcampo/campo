module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  private

  def authenticate
    if session[:user_id]
      unless Current.user = User.find_by(id: session[:user_id])
        sign_out
      end
    end
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
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
