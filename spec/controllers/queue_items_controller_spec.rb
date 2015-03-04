require 'spec_helper'

describe QueueItemsController do
  it "sets @queue_items to the queue items for an authenticated user" do
    bob = Fabricate(:user)
    queue_item1 = Fabricate(:queue_item, user: bob)
    queue_item2 = Fabricate(:queue_item, user: bob)
    session[:user_id] = bob.id
    get :index
    expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
  end
  it "redirects to front page for unauthenticated user" do
    get :index
    expect(response).to redirect_to(root_path)
  end
end
