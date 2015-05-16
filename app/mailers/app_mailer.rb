class AppMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    mail from: 'jojojoship@gmail.com', to: user.email, subject: "Welcome to MyFlix!"
  end

  def password_reset_link(user)
    @user = user
    mail from: 'jojojoship@gmail.com', to: user.email, subject: "Password Reset Link"
  end
end
