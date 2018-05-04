class PasswordResetsController < ApplicationController
  include AuthPassword

  layout 'base'

  before_action :require_auth_password_enabled
  before_action :load_user_from_token, only: [:edit, :update]

  def show
  end

  def create
    user = User.find_by("lower(email) = lower(?)", params[:email])
    if user
      UserMailer.with(user: user).password_reset.deliver_later
    else
      redirect_to password_reset_url, alert: 'User not found.'
    end
  end

  def edit
  end

  def update
    if @user.update params.require(:user).permit(:password, :password_confirmation)
      redirect_to new_session_path, notice: 'Password reset success.'
    else
      render
    end
  end

  private

  def load_user_from_token
    unless @user = User.from_password_reset_token(params[:token])
      redirect_to password_reset_url, alert: 'Token invalid.'
    end
  end
end
