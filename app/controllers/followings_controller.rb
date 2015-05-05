class FollowingsController < ApplicationController
  before_filter :require_user

  def index
    @followings = current_user.followings
  end

  def create
    followed = User.find(params[:followed_id])
    Following.create(follower: current_user, followed: followed)
    redirect_to people_path
  end

  def destroy
    following = Following.find(params[:id])
    following.destroy if following.follower == current_user
    redirect_to people_path
  end
end
