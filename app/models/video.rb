class Video < ActiveRecord::Base
  validates_presence_of :title, :description
  belongs_to :category
  has_many :reviews, -> { order "created_at DESC" }

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_string)
    return [] if search_string.blank?
    Video.where('title LIKE ?', "%#{search_string}%").order('created_at DESC')
  end

  def rating
    video_rating = self.reviews.average(:rating)
    video_rating.round(1) if video_rating
  end
end
