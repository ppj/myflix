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

    it_behaves_like "a gatekeeper redirecting a non-admin user" do
      let(:action) { get :new }
    end

    it "sets a flash message for non-admin" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { post :create }
    end

    it_behaves_like "a gatekeeper redirecting a non-admin user" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      it "redirects back to the add new videos page" do
        category = Fabricate :category
        set_current_admin
        post :create, video: {title: "New Video", category_id: category.id, description: "some thing to watch out for!"}
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a new video" do
        category = Fabricate :category
        set_current_admin
        post :create, video: {title: "New Video", category_id: category.id, description: "some thing to watch out for!"}
        expect(category.videos.count).to eq(1)
      end

      it "sets a flash success message" do
        category = Fabricate :category
        set_current_admin
        post :create, video: {title: "New Video", category_id: category.id, description: "some thing to watch out for!"}
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "does not create a new video"

      it "sets the @video variable"

      it "renders the add new videos form"

      it "sets a flash error message"

    end
  end
end
