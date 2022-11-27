class SessionsController < ApplicationController
  include AuthPassword
  layout 'base'

  before_action :require_auth_password_enabled, only: [:create]

  def new
    if params[:return_to]
      session[:return_to] = URI(params[:return_to]).path
    end
    @user = User.new
  end

  def create
    user = User.where(email: user_params[:email]).first

    if user&.authenticate(user_params[:password])
      sign_in(user)
      redirect_to session.delete(:return_to) || root_path
    else
      @user = User.new email: user_params[:email]
      @user.errors.add(:base, :email_or_password_invalid)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
