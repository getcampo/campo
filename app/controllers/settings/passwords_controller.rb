class Settings::PasswordsController < ApplicationController
  include AuthPassword
  layout 'base'

  before_action :require_sign_in, :require_auth_password_enabled

  def show
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update user_params
      redirect_to settings_password_path, notice: 'Password is successfully updated.'
    else
      render 'update_form'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
