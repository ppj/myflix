class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :fullname, length: {minimum: 2}
  validates :password, on: :create, length: {minimum: 3}
  validates :email, uniqueness: true
end
