module ApplicationHelper
  def options_for_video_rating(selected = nil)
    options_for_select([5,4,3,2,1].map {|n| [pluralize(n, "Star"), n] }, selected)
  end

  def options_for_video_rating_search(selected = nil)
    options_for_select((10..50).map {|n| n/10.0 }, selected)
  end
end
