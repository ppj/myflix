class Video < ActiveRecord::Base
  before_validation :update_rating!

  validates_presence_of :title, :description
  belongs_to :category
  has_many :reviews

  def self.search_by_title(search_string)
    return [] if search_string.blank?
    Video.where('title LIKE ?', "%#{search_string}%").order('created_at DESC')
  end

  private

  def update_rating!
    if self.reviews.empty?
      self.rating = 1.0
    else
      self.rating = self.reviews.average(:rating)
    end
  end
end
