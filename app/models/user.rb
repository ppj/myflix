class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :password, length: {minimum: 3}
  validates :email, length: {minimum: 5}, uniqueness: true
  validates :fullname, length: {minimum: 2}
end
