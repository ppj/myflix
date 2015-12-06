module StripeWrapper
  class Charge
    def self.create(amount:, source:, description:, currency: "aud")
      Stripe::Charge.create(
        amount: amount,
        currency: currency,
        source: source,
        description: description,
      )
    end
  end
end
