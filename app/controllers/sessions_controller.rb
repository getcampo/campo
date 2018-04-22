class SessionsController < ApplicationController
  layout 'session'

  def new
  end

  def create
    identity = Identity.find_or_create_by!(provider: auth_hash[:provider], uid: auth_hash[:uid])
    set_identity(identity)
    if identity.user
      sign_in(identity.user)
      redirect_to root_path
    else
      redirect_to new_user_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
