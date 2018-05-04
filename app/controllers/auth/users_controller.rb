class Auth::UsersController < ApplicationController
  layout 'base'

  before_action :load_identity

  def new
    @user = User.new(
      name: session[:auth_info]['name'],
      username: session[:auth_info]['username'],
      email: session[:auth_info]['email']
    )
  end

  def create
    @user = User.new params.require(:user).permit(:name, :username, :email)
    @user.password = SecureRandom.base58

    if @user.save
      @identity.update(user: @user)
      sign_in(@user)
      redirect_to root_url
    else
      render 'update_form'
    end
  end

  private

  def load_identity
    unless @identity = Identity.find_by(id: session[:identity_id], user: nil)
      redirect_to new_session_url
    end
  end
end
