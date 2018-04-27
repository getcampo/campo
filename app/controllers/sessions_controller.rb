class SessionsController < ApplicationController
  layout 'base'

  def new
  end

  def create
    user = User.where("lower(username) = lower(:login) or lower(email) = lower(:login)", login: params[:login]).first

    if user.authenticate(params[:password])
      sign_in(user)
      redirect_to session[:return_path] || root_path
    else
      redirect_to new_session_url, alert: 'Wrong login or password!'
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
