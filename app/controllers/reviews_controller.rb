class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video  = Video.find(params[:video_id])
    @review = @video.reviews.new(params.require(:review).permit(:body, :rating))
    @review.creator = current_user
    if @review.save
      flash[:success] = "Review was successfully submitted."
      redirect_to video_path(@review.video)
    else
      flash.now[:danger] = "Please fix the highlighted errors before submitting..."
      render 'videos/show'
    end
  end
end
