require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
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

  describe "POST create" do
    let(:current_user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    context "for an authenticated user" do
      before do
        session[:user_id] = current_user.id
      end

      it "adds the current video as the current_user's queue_item" do
        post :create, video_id: video.id
        expect(current_user.queue_items.map(&:video)).to include(video)
      end

      it "associates the queue_item to the logged in user" do
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end

      it "associates the queue_item to the current video" do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "adds a queue_item to the end of the queue" do
        current_user.queue_items.create(video: video)
        post :create, video_id: Fabricate(:video).id
        expect(current_user.queue_items.last.position).to be(current_user.queue_items.map(&:position).max)
      end

      it "redirects to the user's queue index page" do
        post :create, video_id: video.id
        expect(response).to redirect_to(my_queue_path)
      end
    end

    context "for an unuthenticated user" do
      it "redirects to the front page" do
        post :create, video_id: video.id
        expect(response).to redirect_to(root_path)
      end

    end
  end

  describe "DELETE destroy" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let!(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

    context "for an authenticated user" do
      before { session[:user_id] = user.id }

      it "deletes the linked queue_item if found" do
        expect{ delete :destroy, id: queue_item.id }.to change{ user.queue_items.count }.by(-1)
      end

      it "does not delete a queue_item that does not belong to the current user" do
        queue_item2 = Fabricate(:queue_item, user: Fabricate(:user), video: video)
        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq(2)
      end

      it "does not affect user's queue if queue_item is not found" do
        expect{ delete :destroy, id: queue_item.id+10 }.to change{ user.queue_items.count }.by(0)
      end

      it "redirects to the my_queue page" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(my_queue_path)
      end
    end

    it "redirects to the front page for an unauthenticated user" do
      delete :destroy, id: 2
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST update_queue" do
    let(:user) { Fabricate(:user) }
    let!(:queue_item1) { Fabricate(:queue_item, user: user) }
    let!(:queue_item2) { Fabricate(:queue_item, user: user) }
    context "for an authenticated user" do
      before { session[:user_id] = user.id }

      it "redirects to the my_queue page" do
        post :update_queue
        expect(response).to redirect_to(my_queue_path)
      end
    end

    it "redirects to the front page for an unauthenticated user" do
      post :update_queue
      expect(response).to redirect_to(root_path)
    end
  end
end
