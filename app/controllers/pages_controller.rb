class PagesController < ApplicationController
  before_action :require_user, only: [:home]
  def front
    redirect_to videos_path if logged_in?
  end

  def home
    redirect_to videos_path
  end
end
