class SessionsController < ApplicationController
  def create
    identity = Identity.find_or_create_by(provider: auth_hash[:provider], uid: auth_hash[:uid])
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
