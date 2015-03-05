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
      # FIXME: Better error should show if same user tries to submit multiple reviews for the same video
      flash.now[:danger] = "There were errors trying to submit the review."
      render 'videos/show'
    end
  end
end
