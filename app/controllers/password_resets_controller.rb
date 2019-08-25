class PasswordResetsController < ApplicationController
  include AuthPassword
  layout 'session'

  before_action :require_auth_password_enabled
  before_action :load_user_from_token, only: [:edit, :update]

  def show
  end

  def create
    user = User.find_by("lower(email) = lower(?)", params[:email])
    if user
      UserMailer.with(user: user).password_reset.deliver_later
      redirect_to password_reset_url, alert: t('flash.password_reset_email_has_been_send')
    else
      redirect_to password_reset_url, alert: t('flash.user_not_found')
    end
  end

  def edit
  end

  def update
    if @user.update params.require(:user).permit(:password, :password_confirmation)
      User.verifier = Rails.application.message_verifier('User-' + SecureRandom.base64(8))
      redirect_to sign_in_path, notice: t('flash.password_is_successfully_reset')
    else
      render 'update_form'
    end
  end

  private

  def load_user_from_token
    @user = User.from_password_reset_token(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to password_reset_url, alert: t('flash.invalid_token')
  end
end
