# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def password_reset
    @user = User.first
    UserMailer.with(user: User.first).password_reset
  end
end
