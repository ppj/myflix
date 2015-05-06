class FollowingsController < ApplicationController
  before_filter :require_user

  def index
    @followings = current_user.followings
  end

  def create
    followed = User.find(params[:followed_id])
    following = Following.new(follower: current_user, followed: followed)
    if following.save
      flash[:success] = "You have started following #{followed.fullname}."
    else
      if followed == current_user
        flash[:danger] = "You cannot follow yourself."
      else
        flash[:danger] = "You are already following #{followed.fullname}."
      end
    end
    redirect_to people_path
  end

  def destroy
    following = Following.find(params[:id])
    following.destroy if following.follower == current_user
    redirect_to people_path
  end
end
