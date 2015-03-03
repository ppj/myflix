require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it "when no user is logged in, renders the login form" do
      get :new
      expect(response).to render_template(:new)
    end
    it "when a user is logged in, redirects to home-path" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end
  end

  describe 'POST create' do
    let(:test_user) { Fabricate(:user) }

    context "with valid login credentials" do
      before {post :create, email: test_user.email, password: test_user.password}
      it "logs the user in" do
        expect(session[:user_id]).to eq(test_user.id)
      end

      it "then redirects to root-path" do
        expect(response).to redirect_to(root_path)
      end

      it "also notifies the user of a successful login" do
        expect(flash[:success]).to be_present
      end
    end

    it "with invalid login credentials, re-renders the login form" do
      post :create, email: test_user.email, password: test_user.password.upcase
      expect(response).to render_template(:new)
    end
  end

  describe 'GET destroy' do
    it "logs the user out" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root-path after logging out" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
