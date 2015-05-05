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
    let(:bob) { Fabricate :user }
    let(:jane) { Fabricate :user }
    let(:following) { following = Fabricate :following, follower: bob, followed: jane }
    before { set_current_user bob }

    it_behaves_like "a security guard" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "redirects to the people page" do
      delete :destroy, id: following
      expect(response).to redirect_to people_path
    end

    it "deletes the following if current user is the follower" do
      delete :destroy, id: following
      expect(Following.count).to eq(0)
    end

    it "does not delete the following if the current user is not the follower" do
      following2 = Fabricate :following, follower: jane, followed: bob
      delete :destroy, id: following2
      expect(Following.count).to eq(1)
    end
  end

  describe "POST create" do
    let(:bob) { Fabricate :user }
    let(:jane) { Fabricate :user }
    before { set_current_user bob }

    it_behaves_like "a security guard" do
      let(:action) { post :create }
    end

    it "redirects to people page" do
      post :create, followed_id: jane.id
      expect(response).to redirect_to people_path
    end

    it "sets current user as the follower of the indicated user" do
      post :create, followed_id: jane.id
      expect(Following.count).to eq(1)
      expect(Following.first.follower).to eq(bob)
      expect(Following.first.followed).to eq(jane)
    end

    it "does not set up a following if current user is already following the indicated user"
    it "does not set up a following relationship if passed in user is the the same as current user"
  end
end
