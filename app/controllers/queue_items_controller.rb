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
      normalize_user_queue_positions
    end
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_user_queue_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position value."
    else # ActiveRecord::RecordInvalid was not raised
      normalize_user_queue_positions
    end
    redirect_to my_queue_path
  end

  private

  def update_user_queue_positions
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find queue_item_data[:id]
        offset_position = get_new_offset_position queue_item_data[:position]
        queue_item.update_attributes!(position: offset_position) if queue_item.user == current_user
      end
    end
  end

  # To avoid getting a non-unique position value error for a user's queue, temporarily offset the input position value by the number of queue_items in the user's queue (normalize_user_queue_positions will remove the offset later)
  def get_new_offset_position(new_position_input_string)
    if new_position_input_string.to_i.to_s == new_position_input_string
      offset_position = current_user.queue_items.count + new_position_input_string.to_i
    else
      offset_position = "invalid (non-integer) input value for position"
    end
  end

  def normalize_user_queue_positions
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end
end
