require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do
    it "assigns @user when a valid token is supplied" do
      bob = Fabricate :user
      get :show, id: bob.token
      expect(assigns(:user)).to eq(bob)
    end

    it "renders user-token expired page if user is not found" do
      get :show, id: ""
      expect(response).to render_template :invalid_token
    end
  end

  describe "POST create" do
    it "renders user-token expired page if user is not found" do
      post :create, token: "expiredToken", password: "pwd"
      expect(response).to render_template :invalid_token
    end

    it "resets the user's password" do
      bob = Fabricate :user
      post :create, token: bob.token, password: "pwd"
      expect(bob.reload.authenticate("pwd")).to be_truthy
    end

    it "resets the user's token" do
      bob = Fabricate :user
      expect do
        post :create, token: bob.token, password: "pwd"
      end.to change{bob.reload.token}
    end

    it "displays a flash message that the password has been changed" do
      bob = Fabricate :user
      post :create, token: bob.token, password: "pwd"
      expect(flash[:success]).to be_present
    end

    it "redirects to the sign-in page" do
      bob = Fabricate :user
      post :create, token: bob.token, password: "pwd"
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
