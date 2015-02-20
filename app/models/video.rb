class Video < ActiveRecord::Base
  before_validation :update_rating

  validates_presence_of :title, :description
  belongs_to :category
  has_many :reviews

  validates_numericality_of :rating, greater_than_or_equal_to: 1
  validates_numericality_of :rating, less_than_or_equal_to: 5

  def self.search_by_title(search_string)
    return [] if search_string.blank?
    Video.where('title LIKE ?', "%#{search_string}%").order('created_at DESC')
  end

  # private

  def update_rating
    self.rating ||= 1.0 unless self.reviews.any?
  end
end
