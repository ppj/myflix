class AppMailer < ActionMailer::Base
  default from: 'info@myflix.com'

  def welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to MyFlix!"
  end

  def password_reset_link(user)
    @user = user
    mail to: user.email, subject: "Password Reset Link"
  end

  def invitation_email(invitation)
    @invitation = invitation
    mail to: @invitation.invitee_email, subject: "Invitation to join MyFlix.com"
  end
end
