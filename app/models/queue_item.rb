class QueueItem < ActiveRecord::Base
  before_save :set_position

  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video_id, scope: :user_id
  validates_uniqueness_of :position, scope: :user_id
  validates_presence_of :user

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
    queue = self.user ? self.user.queue_items : [] # FIXME: just to pass the tests!!!
    max_position = queue.empty? ? 0 : queue.map(&:position).max
    self.position ||= max_position+1
  end
end
