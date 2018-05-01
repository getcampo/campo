class UserMailer < ApplicationMailer
  def auth_email(email)
    @token = OmniAuth::Strategies::Email.token_for_email(email)

    mail(to: email)
  end

  def password_reset
    @user = params[:user]
    mail(subject: 'Reset password', to: @user.email)
  end
end
