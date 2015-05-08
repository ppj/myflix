require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated user" do
      context "with valid review contents" do
        let(:test_video) { Fabricate :video }
        before do
          set_current_user
          post :create, { video_id: test_video.id, review: Fabricate.attributes_for(:review) }
        end

        it "creates new review" do
          expect(Review.count).to eq(1)
        end

        it "sets the @video to current video" do
          expect(assigns(:video)).to eq(test_video)
        end

        it "associates the review with the current video" do
          expect(Review.first.video).to eq(test_video)
        end

        it "associates the review with the current user" do
          expect(Review.first.creator).to eq(current_user)
        end

        it "redirects to the video show page" do
          expect(response).to redirect_to(video_path test_video)
        end

        it "notifies the user of successful review creation" do
          expect(flash[:success]).to_not be_blank
        end
      end

      context "with invalid review contents" do
        let(:test_video) { Fabricate :video }
        before do
          set_current_user
          post :create, { video_id: test_video.id, review: {body: '2short', rating: 0} }
        end

        it "sets @review to a new Review" do
          expect(assigns(:review)).to be_a_new(Review)
        end

        it "cannot save the new review" do
          expect(Review.count).to eq(0)
        end

        it "sets @video to the current video" do
          expect(assigns(:video)).to eq(test_video)
        end

        it "re-renders the video page with review form" do
          expect(response).to render_template('videos/show')
        end
      end
    end

    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { post :create, video_id: 2, review: Fabricate.attributes_for(:review) }
    end
  end
end
