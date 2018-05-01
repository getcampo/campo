class UserMailer < ApplicationMailer
  def password_reset
    @user = params[:user]
    mail(subject: 'Reset password', to: @user.email)
  end
end
