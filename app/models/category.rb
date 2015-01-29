class Category < ActiveRecord::Base
  has_many :videos, -> {order :title}

  def self.recent_videos(category_name)
    Video.where( category: Category.find_by(name: category_name) ).order('created_at DESC')[0..5]
  end
end
