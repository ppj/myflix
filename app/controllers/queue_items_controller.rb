class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    current_user.queue_items.create(video: Video.find(params[:video_id]))
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find_by(id: params[:id], user: current_user)
    queue_item.destroy if queue_item
    redirect_to my_queue_path
  end

  def update_queue
    redirect_to my_queue_path
  end
end
