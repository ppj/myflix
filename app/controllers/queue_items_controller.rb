class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def new
    current_user.queue_items.create(video: Video.find(params[:video_id]))
    redirect_to my_queue_path
  end
end
