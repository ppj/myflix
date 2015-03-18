class QueueItem < ActiveRecord::Base
  before_validation :set_position, on: :create

  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video_id, scope: :user_id
  validates_presence_of :user
  validates_numericality_of :position, only_integer: true

  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(creator: user, video: video).first
    review.rating if review
  end

  delegate :category, to: :video

  def category_name
    category.name
  end

  private

  def set_position
    queue = QueueItem.where(user: self.user)
    self.position ||= queue.count + 1
  end
end
