require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { get :new }
    end

    it "sets a video to a new Video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new Video
    end

    it "does not allow non-admins to add new video" do
      set_current_user
      get :new
      expect(response).to redirect_to root_path
    end

    it "sets a flash message for non-admin" do
      set_current_user
      get :new
      expect(flash[:info]).to be_present
    end
  end
end
