module Tokenable
  extend ActiveSupport::Concern

  included do
    def generate_token
      self.update_column(:token, unique_token)
    end

    def remove_token
      self.update_column(:token, nil)
    end

    private

    def unique_token
      try_token = nil
      loop do
        try_token = SecureRandom.urlsafe_base64
        break unless self.class.exists?(token: try_token)
      end
      try_token
    end
  end
end
