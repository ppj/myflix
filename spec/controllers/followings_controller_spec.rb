require 'spec_helper'

describe FollowingsController do
  describe "GET index" do
    it_behaves_like "a security guard" do
      let(:action) { get :index }
    end

    it "sets @followings to users followed by current user" do
      bob = Fabricate :user
      set_current_user bob
      jane = Fabricate :user
      alex = Fabricate :user
      following = Fabricate :following, follower: bob, followed: jane
      following1 = Fabricate :following, follower: jane, followed: alex
      get :index
      expect(assigns(:followings)).to eq([following])
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "a security guard" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "redirects to the people page" do
      bob = Fabricate :user
      jane = Fabricate :user
      following = Fabricate :following, follower: bob, followed: jane
      set_current_user bob
      delete :destroy, id: following
      expect(response).to redirect_to people_path
    end

    it "deletes the following if current user is the follower" do
      bob = Fabricate :user
      jane = Fabricate :user
      following = Fabricate :following, follower: bob, followed: jane
      set_current_user bob
      delete :destroy, id: following
      expect(Following.count).to eq(0)
    end

    it "does not delete the following if the current user is not the follower" do
      bob = Fabricate :user
      jane = Fabricate :user
      set_current_user bob
      following2 = Fabricate :following, follower: jane, followed: bob
      delete :destroy, id: following2
      expect(Following.count).to eq(1)
      expect(flash[:danger]).to be_present
    end

    it "displays a message saying following deleted" do
      bob = Fabricate :user
      jane = Fabricate :user
      following = Fabricate :following, follower: bob, followed: jane
      set_current_user bob
      delete :destroy, id: following
      expect(flash[:info]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "a security guard" do
      let(:action) { post :create }
    end

    it "redirects to people page" do
      bob = Fabricate :user
      jane = Fabricate :user
      set_current_user bob
      post :create, followed_id: jane.id
      expect(response).to redirect_to people_path
    end

    context "with valid inputs" do
      it "sets current user as the follower of the indicated user" do
        bob = Fabricate :user
        jane = Fabricate :user
        set_current_user bob
        post :create, followed_id: jane.id
        expect(Following.count).to eq(1)
        expect(Following.first.follower).to eq(bob)
        expect(Following.first.followed).to eq(jane)
      end

      it "displays success message" do
        bob = Fabricate :user
        jane = Fabricate :user
        set_current_user bob
        post :create, followed_id: jane.id
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "does not set up a following if current user is already following the indicated user and displays an error" do
        bob = Fabricate :user
        jane = Fabricate :user
        set_current_user bob
        Following.create(follower: bob, followed: jane)
        post :create, followed_id: jane.id
        expect(Following.count).to eq(1)
      end

      it "does not set up a following relationship if passed in user is the the same as current user" do
        bob = Fabricate :user
        set_current_user bob
        post :create, followed_id: bob.id
        expect(Following.count).to eq(0)
      end

      it "displays an error message" do
        bob = Fabricate :user
        jane = Fabricate :user
        set_current_user bob
        Following.create(follower: bob, followed: jane)
        post :create, followed_id: jane.id
        expect(flash[:danger]).to be_present
      end
    end
  end
end
