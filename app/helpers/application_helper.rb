module ApplicationHelper
  def video_rating
    @video.rating ? "#{@video.rating}/5.0" : "N/A"
  end

  def options_for_video_rating(selected = nil)
    options_for_select([5,4,3,2,1].map {|n| [pluralize(n, "Star"), n] }, selected)
  end
end
