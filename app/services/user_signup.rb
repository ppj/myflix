class UserSignup
  attr_reader :error_message

  def self.perform(user:, invitation_token:, stripe_token:)
    new(user, invitation_token, stripe_token).perform
  end

  def initialize(user, invitation_token, stripe_token)
    @user = user
    @invitation_token = invitation_token
    @stripe_token = stripe_token
  end

  def perform
    if user.valid?
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      charge = StripeWrapper::Charge.create(
        amount: 999,
        source: stripe_token,
        description: "MyFlix Sign Up Charge for #{user.email}"
      )
      if charge.successful?
        user.save
        handle_invitation
        AppMailer.welcome_email(user).deliver
        @success = true
      else
        @error_message = charge.error_message
      end
    else
       @error_message = "Please fix the highlighted errors before continuing..."
    end
    self
  end

  def successful?
    @success.present?
  end

  private

  attr_reader :user, :invitation_token, :stripe_token

  def handle_invitation
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      invitation.inviter.follow(user)
      user.follow(invitation.inviter)
      invitation.remove_token
    end
  end
end
