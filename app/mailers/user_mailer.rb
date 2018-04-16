class UserMailer < ApplicationMailer
  def auth_email(email)
    mail(to: email)
  end
end
