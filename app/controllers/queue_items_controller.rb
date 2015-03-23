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
    if queue_item
      queue_item.destroy
      current_user.normalize_queue_item_positions
    end
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_user_queue_attributes
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position value."
    else # ActiveRecord::RecordInvalid was not raised
      current_user.normalize_queue_item_positions
    end
    redirect_to my_queue_path
  end

  private

  def update_user_queue_attributes
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find queue_item_data[:id]
        queue_item.update_attributes!(position: queue_item_data[:position], rating: queue_item_data[:rating]) if queue_item.user == current_user
      end
    end
  end
end
