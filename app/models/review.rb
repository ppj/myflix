class Review < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :video

  validates_presence_of :user_id
  validates_presence_of :video_id
  validates_inclusion_of :rating, in: 1..5
  validates :body, length: { minimum: 10 }
  validates_uniqueness_of :user_id, scope: :video_id
end
