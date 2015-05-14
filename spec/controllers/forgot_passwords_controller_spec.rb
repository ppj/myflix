require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with valid email address" do
      it "sends an email with a link to reset that user's password" do
        bob = Fabricate :user
        post :create, email: bob.email
        email_message = ActionMailer::Base.deliveries.last
        expect(email_message).to be_present
        expect(email_message.to).to eq([bob.email])
        ActionMailer::Base.deliveries.clear
      end

      it "redirects to password-reset confirmation page" do
        bob = Fabricate :user
        post :create, email: bob.email
        expect(response).to redirect_to(confirm_password_reset_path)
      end
    end

    context "with invalid email address" do
      it "redirects to the forgot-password form" do
        post :create, email: 'invalid@email.com'
        expect(response).to redirect_to(forgot_password_path)
      end

      it "shows an error message about the email address" do
        post :create, email: ''
        expect(flash[:danger]).to be_present
      end

      it "does not send an email" do
        ActionMailer::Base.deliveries.clear
        post :create, email: 'what@ever.com'
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET reset" do
    it "assigns @user when a valid token is supplied" do
      bob = Fabricate :user
      get :reset, token: bob.token
      expect(assigns(:user)).to eq(bob)
    end

    it "renders user-token expired page if user is not found" do
      get :reset, token: ""
      expect(response).to render_template :invalid_token
    end
  end

  describe "POST update" do
    it "renders user-token expired page if user is not found" do
      post :update, token: "expiredToken", password: "pwd"
      expect(response).to render_template :invalid_token
    end

    it "resets the user's password" do
      bob = Fabricate :user
      post :update, token: bob.token, password: "pwd"
      expect(bob.reload.authenticate("pwd")).to be_truthy
    end

    it "resets the user's token" do
      bob = Fabricate :user
      expect do
        post :update, token: bob.token, password: "pwd"
      end.to change{bob.reload.token}
    end

    it "displays a flash message that the password has been changed" do
      bob = Fabricate :user
      post :update, token: bob.token, password: "pwd"
      expect(flash[:success]).to be_present
    end

    it "redirects to the sign-in page" do
      bob = Fabricate :user
      post :update, token: bob.token, password: "pwd"
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
