class QueueItem < ActiveRecord::Base
  before_validation :set_position, on: :create

  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video_id, scope: :user_id
  validates_presence_of :user
  validates_numericality_of :position, only_integer: true

  delegate :title, to: :video, prefix: :video

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_attribute(:rating, new_rating) # update_attribute skips validations
    else
      review = Review.new(creator: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  delegate :category, to: :video

  def category_name
    category.name
  end

  private

  def review
    @review ||= Review.find_by(creator: user, video: video)
  end

  def set_position
    queue = QueueItem.where(user: user)
    self.position ||= queue.count + 1
  end
end
