class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text    :body
      t.integer :user_id, :video_id
      t.timestamps
    end
  end
end
