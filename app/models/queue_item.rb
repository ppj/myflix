class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video_id, scope: :user_id

  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(creator: user, video: video).first
    review.rating if review
  end

  delegate :category, to: :video

  def category_name
    category.name
  end
end
