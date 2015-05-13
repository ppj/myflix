class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews, -> { order "created_at DESC" }
  has_many :queue_items, -> { order :position }

  has_many :followings, foreign_key: :follower_id
  has_many :followeds, through: :followings

  has_many :inverse_followings, class_name: "Following", foreign_key: :followed_id
  has_many :followers, through: :inverse_followings

  validates :password, length: {minimum: 3}
  validates :email, length: {minimum: 5}, uniqueness: true
  validates :fullname, length: {minimum: 2}

  before_create :generate_token

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued?(video)
    queue_items.pluck(:video_id).include? video.id
  end

  def follows?(another_user)
    followeds.include?(another_user)
  end

  def can_follow?(another_user)
    !(follows?(another_user) || self == another_user)
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
