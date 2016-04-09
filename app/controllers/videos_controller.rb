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

  def advanced_search
    if params[:query]
      @videos = Video.search(params[:query]).records.to_a
    else
      @videos = []
    end
  end
end
