class PasswordResetsController < ApplicationController
  layout 'base'

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
    @user = User.from_password_reset_token(params[:token])

    if @user
      render
    else
      redirect_to password_reset_url, alert: 'Token invalid.'
    end
  end

  def update
    @user = User.from_password_reset_token(params[:token])

    if @user.update params.require(:user).permit(:password, :password_confirmation)
      redirect_to new_session_path, notice: 'Password reset success.'
    else
      render
    end
  end
end
