class AuthsController < ApplicationController
  skip_before_action :require_site

  def callback
    auth_hash = request.env['omniauth.auth']
    identity = Identity.find_or_create_by(provider: auth_hash[:provider], uid: auth_hash[:uid])
    identity.update(name: auth_hash[:info][:name])

    if identity.user
      sign_in(identity.user)
      redirect_to session.delete(:return_to) || root_path
    else
      session[:identity_id] = identity.id
      session[:auth_info] = {
        name: auth_hash[:info][:name],
        username: auth_hash[:info][:username] || auth_hash[:info][:name],
        email: auth_hash[:info][:email]
      }
      redirect_to new_auth_user_path
    end
  end
end
