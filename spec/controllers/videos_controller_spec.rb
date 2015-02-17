require 'spec_helper'

describe VideosController do

  describe "GET show" do
    let(:test_video) { Fabricate(:video) }

    it "redirects to root for an unauthenticated user" do
      get :show, id: test_video.id
      expect(response).to redirect_to(root_path)
    end

    it "sets @video for an authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: test_video.id
      expect(assigns(:video)).to eq(test_video)
    end
  end

  describe "POST search" do
    it "redirects to root for an unauthenticated user" do
      get :search, search_string: 'A'
      expect(response).to redirect_to(root_path)
    end

    it "finds a Video based on given name" do
      test_video = Fabricate(:video, title: 'The Big Bang Theory')
      session[:user_id] = Fabricate(:user).id
      get :search, search_string: 'heor'
      expect(assigns(:videos)).to eq([test_video])
    end
  end

end
