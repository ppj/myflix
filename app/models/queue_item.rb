class QueueItem < ActiveRecord::Base
  before_create :set_position
  after_destroy :reassign_positions

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
    queue = self.user ? self.user.queue_items : [] # FIXME: just to pass the uniqueness shoulda matcher tests!!!
    max_position = queue.empty? ? 0 : queue.count
    self.position = max_position + 1
  end

  def reassign_positions
    remaining_queue = QueueItem.all.select do |queue_item|
      queue_item.user == self.user and queue_item.position > self.position
    end
    remaining_queue.each do |queue_item|
      queue_item.update(position: queue_item.position - 1)
    end
  end
end
