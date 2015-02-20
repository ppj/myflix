class Review < ActiveRecord::Base
  validates_inclusion_of :rating, in: 1..5
  validates :body, length: { minimum: 10 }
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :video
end
