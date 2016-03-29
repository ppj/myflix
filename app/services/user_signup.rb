class UserSignup
  attr_reader :error_message

  def self.perform(user:, stripe_token:, invitation_token: nil)
    new(user, stripe_token, invitation_token).perform
  end

  def initialize(user, stripe_token, invitation_token)
    @user = user
    @stripe_token = stripe_token
    @invitation_token = invitation_token
  end

  def perform
    if user.valid?
      @new_subscription = subscribe_new_customer
      if new_subscription.successful?
        user_sign_up_success_steps
      else
        @error_message = new_subscription.error_message
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

  attr_reader :user, :invitation_token, :stripe_token, :new_subscription

  def subscribe_new_customer
    StripeWrapper::Customer.create(
      email: user.email,
      source: stripe_token,
      description: "MyFlix subscription for #{user.email}"
    )
  end

  def user_sign_up_success_steps
    user.customer_token = new_subscription.customer_token
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
