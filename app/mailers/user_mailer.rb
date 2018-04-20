class UserMailer < ApplicationMailer
  def auth_email(email)
    @token = OmniAuth::Strategies::Email.token_for_email(email)

    mail(to: email)
  end
end
