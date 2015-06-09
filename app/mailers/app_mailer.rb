class AppMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Welcome to MyFlix!"
  end

  def password_reset_link(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Password Reset Link"
  end

  def invitation(name, email, message)
    @name = name
    @message = message
    @email = email
    mail from: 'info@myflix.com', to: @email, subject: "Invitation to join MyFlix.com"
  end
end
