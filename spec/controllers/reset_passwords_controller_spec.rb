require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do
    it "assigns @user when a valid token is supplied" do
      bob = Fabricate :user
      bob.update_column(:token, "abcedf")
      get :show, id: "abcedf"
      expect(assigns(:user)).to eq(bob)
    end

    it "renders user-token expired page if user is not found" do
      get :show, id: "abcdef"
      expect(response).to render_template :invalid_token
    end
  end

  describe "POST create" do
    it "renders user-token expired page if user is not found" do
      post :create, token: "abcdef", password: "new_pwd"
      expect(response).to render_template :invalid_token
    end

    it "resets the user's password" do
      bob = Fabricate :user
      bob.update_column(:token, "abcdef")
      post :create, token: "abcdef", password: "new_pwd"
      expect(bob.reload.authenticate("new_pwd")).to be_truthy
    end

    it "deletes the user's token" do
      bob = Fabricate :user
      bob.update_column(:token, "abcdef")
      post :create, token: "abcdef", password: "new_pwd"
      expect(bob.reload.token).to be_nil
    end

    it "displays a flash message that the password has been changed" do
      bob = Fabricate :user
      bob.update_column(:token, "abcdef")
      post :create, token: "abcdef", password: "new_pwd"
      expect(flash[:success]).to be_present
    end

    it "redirects to the sign-in page" do
      bob = Fabricate :user
      bob.update_column(:token, "abcdef")
      post :create, token: "abcdef", password: "new_pwd"
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
