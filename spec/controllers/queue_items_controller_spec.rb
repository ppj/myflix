require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do
    before { set_current_user }
    it "sets @queue_items to the queue items for an authenticated user" do
      queue_item1 = Fabricate(:queue_item, user: current_user)
      queue_item2 = Fabricate(:queue_item, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "a security guard" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    context "for an authenticated user" do
      before { set_current_user }

      it "adds the current video as the current_user's queue_item" do
        video = Fabricate :video
        post :create, video_id: video.id
        expect(current_user.queue_items.map(&:video)).to include(video)
      end

      it "associates the queue_item to the logged in user" do
        video = Fabricate :video
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end

      it "associates the queue_item to the current video" do
        video = Fabricate :video
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "adds a queue_item to the end of the queue" do
        video = Fabricate :video
        current_user.queue_items.create(video: video)
        post :create, video_id: Fabricate(:video).id
        expect(current_user.queue_items.last.position).to be(current_user.queue_items.map(&:position).max)
      end

      it "redirects to the user's queue index page" do
        video = Fabricate :video
        post :create, video_id: video.id
        expect(response).to redirect_to(my_queue_path)
      end
    end

    it_behaves_like "a security guard" do
      let(:action) { post :create, video_id: 3 }
    end
  end

  describe "DELETE destroy" do

    context "for an authenticated user" do
      before { set_current_user }

      it "deletes the linked queue_item if found" do
        queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        expect{ delete :destroy, id: queue_item.id }.to change{ current_user.queue_items.count }.by(-1)
      end

      it "normalizes the positions in user's queue after deletion" do
        queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        queue_item3 = Fabricate(:queue_item, user: current_user, position: 3)
        delete :destroy, id: queue_item2.id
        expect(queue_item3.reload.position).to eq(2)
      end

      it "does not delete a queue_item that does not belong to the current user" do
        queue_item2 = Fabricate(:queue_item, user: Fabricate(:user))
        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq(1)
      end

      it "does not affect user's queue if queue_item is not found" do
        expect{ delete :destroy, id: 10 }.to change{ current_user.queue_items.count }.by(0)
      end

      it "redirects to the my_queue page" do
        queue_item = Fabricate(:queue_item, user: current_user, position: 1)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(my_queue_path)
      end
    end

    it_behaves_like "a security guard" do
      let(:action) { delete :destroy, id: 2 }
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      before { set_current_user }
      it "redirects to the my_queue page" do
        post :update_queue, queue_items: []
        expect(response).to redirect_to(my_queue_path)
      end

      it "reassigns positions to the queue items" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "normalizes positions after reassignment" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      context "with repeated position input" do
        it "repositions item if new postion > current position" do
          queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 2}]
          expect(queue_item1.reload.position).to eq(2)
          expect(queue_item2.reload.position).to eq(1)
        end

        it "does not reposition if new position = current_position - 1" do
          queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 1}]
          expect(queue_item1.reload.position).to eq(1)
          expect(queue_item2.reload.position).to eq(2)
        end

        it "repositions item to (new position + 1) if new postion < current position - 1" do
          queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
          queue_item3 = Fabricate(:queue_item, user: current_user, position: 3)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 2}, {id: queue_item3.id, position: 1}]
          expect(queue_item1.reload.position).to eq(1)
          expect(queue_item2.reload.position).to eq(3)
          expect(queue_item3.reload.position).to eq(2)
        end
      end

      it "repositions item to the end if new position >= number of queue items" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "repositions item to the start if new position (<)= 0" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 0}]
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
      before { set_current_user }
      it "does not do any position reassignment if any position is not an integer" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 9.3434}]
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item2.reload.position).to eq(2)
      end

      it "sets the flash error message" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 2.3434}]
        expect(flash[:danger]).to be_present
      end

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: []
        expect(response).to redirect_to(my_queue_path)
      end
    end

    it_behaves_like "a security guard" do
      let(:action) { post :update_queue }
    end
  end
end
