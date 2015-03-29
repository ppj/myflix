require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    before { set_current_user }
    it "when a user is already logged in, redirects to home-path" do
      get :new
      expect(response).to redirect_to(home_path)
    end
  end

  describe 'POST create' do
    let(:new_user) { Fabricate(:user) }
    context "with valid login credentials" do
      before do
        post :create, email: new_user.email, password: new_user.password
      end

      it "logs the user in" do
        expect(session[:user_id]).to eq(new_user.id)
      end

      it "then redirects to root-path" do
        expect(response).to redirect_to(root_path)
      end

      it "also notifies the user of a successful login" do
        expect(flash[:success]).to be_present
      end
    end

    it "with invalid login credentials, re-renders the login form" do
      post :create, email: new_user.email, password: new_user.password.upcase
      expect(response).to render_template(:new)
    end
  end

  describe 'DELETE destroy' do
    it "logs the user out" do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root-path after logging out" do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
