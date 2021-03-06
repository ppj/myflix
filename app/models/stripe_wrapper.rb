module StripeWrapper
  class Charge
    attr_reader :error_message

    def initialize(response, error_message)
      @response = response
      @error_message = error_message
    end

    def self.create(amount:, source:, description:, currency: "aud")
      begin
        response = Stripe::Charge.create(
          amount: amount,
          currency: currency,
          source: source,
          description: description,
        )
        new(response, nil)
      rescue Stripe::CardError => e
        new(nil, e.message)
      end
    end

    def successful?
      @response.present?
    end
  end

  class Customer
    attr_reader :error_message

    def initialize(response, error_message)
      @response = response
      @error_message = error_message
    end

    def self.create(email:, source:, description:)
      begin
        response = Stripe::Customer.create(
          email: email,
          plan: :base,
          source: source,
          description: description,
        )
        new(response, nil)
      rescue Stripe::CardError => e
        new(nil, e.message)
      end
    end

    def successful?
      @response.present?
    end

    def customer_token
      @response.id
    end
  end
end
