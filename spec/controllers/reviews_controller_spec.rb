require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated user" do
      context "with valid review contents" do
        before do
          session[:user_id] = Fabricate(:user).id
          post :create, { video_id: Fabricate(:video).id, review: Fabricate.attributes_for(:review) }
        end

        it "creates new review" do
          expect(Review.count).to eq(1)
        end

        it "sets the @video to current video" do
          expect(assigns(:video)).to eq(Review.first.video)
        end

        it "then redirects to the video show page" do
          expect(response).to redirect_to(video_path Review.first.video)
        end

        it "notifies the user of successful review creation" do
          expect(flash[:success]).to_not be_blank
        end
      end

      context "with invalid review contents" do
        before do
          session[:user_id] = Fabricate(:user).id
          post :create, { video_id: Fabricate(:video).id, review: {body: '2short', rating: 0} }
        end
        it "sets @review to a new Review" do
          expect(assigns(:review)).to be_a_new(Review)
        end

        it "cannot save the new review" do
          expect(Review.count).to eq(0)
        end

        it "re-renders the review form" do
          expect(response).to render_template('videos/show')
        end
      end
    end

    context "with unauthenticated user" do
      it "redirects to home page" do
        post :create, { video_id: Fabricate(:video).id, review: Fabricate.attributes_for(:review) }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
