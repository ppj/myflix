require 'spec_helper'

describe StripeWrapper::Charge do
  describe '.create' do
    before do
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    end
    let(:token_id) do
      Stripe::Token.create(
        :card => {
          :number => card_number,
          :exp_month => 12,
          :exp_year => Time.now.year + 2,
          :cvc => "314"
        },
      ).id
    end
    subject(:response) do
      StripeWrapper::Charge.create(
        amount: 400,
        source: token_id,
        description: "Charge for test@example.com"
      )
    end

    context "for a valid card number" do
      let(:card_number) { "4111111111111111" }

      it "makes a successful charge", :vcr do
        expect(response).to be_successful
      end
    end

    context "for a card number that is declined" do
      let(:card_number) { "4000000000000002" }

      it "makes a card declined charge", :vcr do
        expect(response).to_not be_successful
      end

      it "assigns a card declined error message", :vcr do
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
