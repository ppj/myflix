class Following < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates_presence_of :follower_id
  validates_presence_of :followed_id
  validates_uniqueness_of :follower_id, scope: :followed_id
  validate :cannot_follow_self

  private

  def cannot_follow_self
    @errors.add(:base, "You cannot follow yourself") if follower_id == followed_id
  end
end
