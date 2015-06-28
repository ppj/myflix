require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { get :new }
    end

    it "does not allow non-admins to add new video" do
      bob = Fabricate :user
      set_current_user bob
      get :new
      expect(response).to redirect_to root_path
    end

    it "allows admins to see a new video form" do
      bob = Fabricate :user, admin: true
      set_current_user bob
      get :new
      expect(response).to render_template :new
    end
  end
end
