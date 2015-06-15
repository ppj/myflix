module Tokenable
  extend ActiveSupport::Concern

  included do
    after_create :generate_token

    private

    def generate_token
      update_column :token, SecureRandom.urlsafe_base64
    end
  end
end
