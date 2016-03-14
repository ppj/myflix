class VideosController < ApplicationController
  before_action :require_user, except: [:index]

  def index
    redirect_to root_path unless logged_in?
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search_string])
  end

end
