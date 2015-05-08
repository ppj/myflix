class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :follower_id, :followed_id
      t.timestamps
    end
  end
end
