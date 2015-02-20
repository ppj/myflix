class AddRatingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :rating, :decimal, scale: 1, precision: 2
  end
end
