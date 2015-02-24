class Review < ActiveRecord::Base
  after_save :update_video_rating!

  validates_inclusion_of :rating, in: 1..5
  validates :body, length: { minimum: 10 }
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :video

  private

  def update_video_rating!
    video.save if video
  end
end
