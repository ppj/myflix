require 'spec_helper'

describe VideosController do
  before { sign_in_user }

  describe "GET show" do
    let(:test_video) { Fabricate(:video) }

    it "redirects to root for an unauthenticated user" do
      sign_out
      get :show, id: test_video.id
      expect(response).to redirect_to(root_path)
    end

    it "sets @video for an authenticated user" do
      get :show, id: test_video.id
      expect(assigns(:video)).to eq(test_video)
    end

    it "sets @review to a new review for an authenticated user" do
      get :show, id: test_video.id
      expect(assigns(:review)).to be_a_new(Review)
    end
  end

  describe "POST search" do
    it "redirects to root for an unauthenticated user" do
      sign_out
      get :search, search_string: 'A'
      expect(response).to redirect_to(root_path)
    end

    it "finds a Video based on given name" do
      test_video = Fabricate(:video, title: 'The Big Bang Theory')
      get :search, search_string: 'heor'
      expect(assigns(:videos)).to eq([test_video])
    end
  end

end
