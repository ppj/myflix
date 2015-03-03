module ApplicationHelper
  def video_rating
    @video.rating ? "#{@video.rating}/5.0" : "N/A"
  end
end
