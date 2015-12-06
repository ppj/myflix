require 'spec_helper'

describe StripeWrapper::Charge do
  describe '.create' do
    it "makes a successful charge", :vcr do
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      token_id = Stripe::Token.create(
        :card => {
          :number => "4242424242424242",
          :exp_month => 12,
          :exp_year => 2.years.from_now,
          :cvc => "314"
        },
      ).id

      response = StripeWrapper::Charge.create(
        amount: 400,
        source: token_id,
        description: "Charge for test@example.com"
      )

      expect(response.amount).to eq 400
      expect(response.status).to eq "succeeded"
    end
  end
end
