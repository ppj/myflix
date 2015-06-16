module Tokenable
  extend ActiveSupport::Concern

  included do
    def generate_token
      self.update_column(:token, SecureRandom.urlsafe_base64)
    end

    def remove_token
      self.update_column(:token, nil)
    end
  end
end
