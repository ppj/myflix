require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:test_user)  { Fabricate(:user) }
    let(:test_video) { Fabricate(:video) }

    it "redirects to home page when no user is signed in" do
      get :show, id: test_video.id
      expect(response).to redirect_to(root_path)
    end

    it "finds a Video based on given name" do
      session[:user_id] = test_user.id
      get :show, id: test_video.id
      expect(assigns(:video)).to eq(test_video)
    end

    it "renders the show template" do
      session[:user_id] = test_user.id
      get :show, id: test_video.id
      expect(response).to render_template(:show)
    end
  end
end
