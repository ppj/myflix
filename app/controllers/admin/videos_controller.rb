class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    Video.create video_params
    flash[:success] = "Video created successfully."
    redirect_to new_admin_video_path
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description)
  end
end
