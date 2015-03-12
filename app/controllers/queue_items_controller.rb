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
    begin
      queue_item = QueueItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    else
      queue_item.destroy if queue_item
    end
    redirect_to my_queue_path
  end
end
