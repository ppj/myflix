class FollowingsController < ApplicationController
  before_filter :require_user

  def index
    @followings = current_user.followings
  end

  def destroy
    following = Following.find(params[:id])
    following.destroy if following.follower == current_user
    redirect_to people_path
  end
end
