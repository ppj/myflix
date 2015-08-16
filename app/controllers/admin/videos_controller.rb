class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new video_params
    if @video.save
      flash[:success] = "Video '#{@video.title}' added successfully."
      redirect_to new_admin_video_path
    else
      flash.now[:danger] = "Please fix the errors in the form"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover)
  end
end
