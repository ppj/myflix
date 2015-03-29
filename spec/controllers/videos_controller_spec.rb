require 'spec_helper'

describe VideosController do
  before { set_current_user }

  describe "GET show" do
    let(:test_video) { Fabricate(:video) }

    it_behaves_like "a security guard" do
      let(:action) { get :show, id: test_video.id }
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
    it_behaves_like "a security guard" do
      let(:action) { get :search, search_string: 'A' }
    end

    it "finds a Video based on given name" do
      test_video = Fabricate(:video, title: 'The Big Bang Theory')
      get :search, search_string: 'heor'
      expect(assigns(:videos)).to eq([test_video])
    end
  end

end
