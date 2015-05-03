class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews, -> { order "created_at DESC" }
  has_many :queue_items, -> { order :position }

  validates :password, length: {minimum: 3}
  validates :email, length: {minimum: 5}, uniqueness: true
  validates :fullname, length: {minimum: 2}

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued?(video)
    queue_items.map(&:video).include? video
  end
end
