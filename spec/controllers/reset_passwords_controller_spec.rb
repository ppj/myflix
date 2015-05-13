require 'spec_helper'

describe ResetPasswordsController do
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
      it "does not send an email"
      it "redirects to the forgot-password form"
      it "shows an error message about the email address"
    end
  end
end
