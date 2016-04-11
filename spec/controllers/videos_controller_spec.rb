require 'spec_helper'

describe VideosController do
  describe "GET index" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { get :index }
    end

    it "sets @categories to a list of all categories" do
      set_current_user
      cat1 = Fabricate(:category)
      cat2 = Fabricate(:category)
      get :index
      expect(assigns(:categories)).to match_array([cat1, cat2])
    end
  end

  describe "GET show" do
    let(:test_video) { Fabricate(:video) }

    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { get :show, id: test_video.id }
    end

    it "sets @video for an authenticated user" do
      set_current_user
      get :show, id: test_video.id
      expect(assigns(:video)).to eq(test_video)
    end

    it "sets @review to a new review for an authenticated user" do
      set_current_user
      get :show, id: test_video.id
      expect(assigns(:review)).to be_a_new(Review)
    end
  end

  describe "POST search" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { get :search, search_string: 'A' }
    end

    it "finds a Video based on given name" do
      set_current_user
      test_video = Fabricate(:video, title: 'The Big Bang Theory')
      get :search, search_string: 'heor'
      expect(assigns(:videos)).to eq([test_video])
    end
  end
end
