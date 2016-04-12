require 'spec_helper'

describe "deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_17uLxTDKp2PH1im8jrOj0daw",
      "object" => "event",
      "api_version" => "2015-08-19",
      "created" => 1459254511,
      "data" => {
        "object" => {
          "id" => "ch_17uLxTDKp2PH1im8vbZactJx",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1459254511,
          "currency" => "aud",
          "customer" => "cus_8Aay9fqkNYjIzY",
          "description" => "failed payment test",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_17uLxTDKp2PH1im8vbZactJx/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_17uLwZDKp2PH1im8BBWkF0o3",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_8Aay9fqkNYjIzY",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 3,
            "exp_year" => 2017,
            "fingerprint" => "NKE3YB0x2GpksC2Y",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_8AhM8V5f4NZnqc",
      "type" => "charge.failed"
    }
  end

  it "deactivates the associated user on failed payment", :vcr do
    bob = Fabricate(:user, customer_token: "cus_8Aay9fqkNYjIzY")
    post "/stripe_events", event_data
    expect(bob.reload).to_not be_active
  end

end
