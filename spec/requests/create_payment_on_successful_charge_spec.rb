require 'spec_helper'

describe "create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_17uE6aDKp2PH1im8iSw2wPZx",
      "object" => "event",
      "api_version" => "2015-08-19",
      "created" => 1459224324,
      "data" => {
        "object" => {
          "id" => "ch_17uE6aDKp2PH1im8AYFJLVtO",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => "txn_17uE6aDKp2PH1im8q5tUjOJj",
          "captured" => true,
          "created" => 1459224324,
          "currency" => "aud",
          "customer" => "cus_8AZFQTHr2qBeY8",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {},
          "invoice" => "in_17uE6aDKp2PH1im8QmyxW8dS",
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_17uE6aDKp2PH1im8AYFJLVtO/refunds"

          },
          "shipping" => nil,
          "source" => {
            "id" => "card_17uE6YDKp2PH1im8b8ChEPns",
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
            "customer" => "cus_8AZFQTHr2qBeY8",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 3,
            "exp_year" => 2017,
            "fingerprint" => "0HbsD6QYJI5p2850",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil

          },
          "source_transfer" => nil,
          "statement_descriptor" => "MyFlix Base",
          "status" => "succeeded"

        }

      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_8AZFfWKgaawlwm",
      "type" => "charge.succeeded"

    }
  end

  it "creates payment based on the Stripe webhook for a successful charge", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq 1
  end

  it "associates the user with newly created payment", :vcr do
    bob = Fabricate(:user, customer_token: "cus_8AZFQTHr2qBeY8")
    post "/stripe_events", event_data
    expect(Payment.last.user).to eq bob
  end

  it "has the correct amount for the newly created payment", :vcr do
    bob = Fabricate(:user, customer_token: "cus_8AZFQTHr2qBeY8")
    post "/stripe_events", event_data
    expect(Payment.last.amount).to eq 999
  end

  it "has the correct reference id for the newly created payment", :vcr do
    bob = Fabricate(:user, customer_token: "cus_8AZFQTHr2qBeY8")
    post "/stripe_events", event_data
    expect(Payment.last.reference_id).to eq "ch_17uE6aDKp2PH1im8AYFJLVtO"
  end
end
