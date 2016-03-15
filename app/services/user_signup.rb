class UserSignup
  attr_reader :error_message

  def self.perform(user:, stripe_token:, invitation_token: nil)
    new(user, stripe_token, invitation_token).perform
  end

  def initialize(user, stripe_token, invitation_token)
    @user = user
    @stripe_token = stripe_token
    @invitation_token = invitation_token
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  end

  def perform
    if user.valid?
      charge_result = charge_credit_card
      if charge_result.successful?
        user_sign_up_success_steps
      else
        @error_message = charge_result.error_message
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

  def charge_credit_card
    StripeWrapper::Charge.create(
      amount: 999,
      source: stripe_token,
      description: "MyFlix Sign Up Charge for #{user.email}"
    )
  end

  def user_sign_up_success_steps
    user.save
    handle_invitation
    AppMailer.welcome_email(user).deliver
    @success = true
  end

  def handle_invitation
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      invitation.inviter.follow(user)
      user.follow(invitation.inviter)
      invitation.remove_token
    end
  end
end
