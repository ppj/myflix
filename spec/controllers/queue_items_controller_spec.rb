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
    let!(:queue_item) { Fabricate(:queue_item, user: user, position: 1) }

    context "for an authenticated user" do
      before { session[:user_id] = user.id }

      it "deletes the linked queue_item if found" do
        expect{ delete :destroy, id: queue_item.id }.to change{ user.queue_items.count }.by(-1)
      end

      it "normalizes the positions in user's queue after deletion" do
        queue_item2 = Fabricate(:queue_item, user: user, position: 2)
        queue_item3 = Fabricate(:queue_item, user: user, position: 3)
        delete :destroy, id: queue_item2.id
        expect(queue_item3.reload.position).to eq(2)
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
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let(:queue_item1) { Fabricate(:queue_item, user: user, position: 1, video: video1) }
    let(:queue_item2) { Fabricate(:queue_item, user: user, position: 2, video: video2) }

    context "with valid inputs" do
      before { session[:user_id] = user.id }

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: []
        expect(response).to redirect_to(my_queue_path)
      end

      it "reassigns positions to the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "normalizes positions after reassignment" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "positions an item AFTER an item with the same position number" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "does not reassign positions if queue item doesn't belong to logged in user" do
        queue_item3 = Fabricate(:queue_item, position: 10)
        post :update_queue, queue_items: [{id: queue_item3.id, position: 1}]
        expect(queue_item3.reload.position).to eq(10)
      end
    end

    context "with invalid inputs" do
      before { session[:user_id] = user.id }

      it "does not do any position reassignment if any position is not an integer" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 9.3434}]
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item2.reload.position).to eq(2)
      end

      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 2.3434}]
        expect(flash[:danger]).to be_present
      end

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: []
        expect(response).to redirect_to(my_queue_path)
      end
    end

    context "for an unauthenticated user" do
      it "redirects to the front page for an unauthenticated user" do
        post :update_queue
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
